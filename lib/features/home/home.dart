import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../IA/kiyanza_ia.dart';
import '../../core/network/app_exceptions.dart';
import '../../core/providers/dashboard_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/campagnes/campagne_models.dart';
import '../../data/models/dashboard/dashboard_models.dart';
import '../../simulation/recommendation.dart';
import '../../campagnes/campagne.dart';
import '../../../monitoring_radio/monitoring.dart';
import '../notification/notification.dart';
import '../mon_profil/profil.dart';

/// Montant FCFA compact : 2 450 000 → « 2,45M », 82 600 → « 82,6K ».
String formatCompactAmount(double value) {
  String trim(double v, int digits) =>
      v.toStringAsFixed(digits).replaceFirst(RegExp(r'\.?0+$'), '').replaceAll('.', ',');
  if (value >= 1e9) return '${trim(value / 1e9, 2)}Md';
  if (value >= 1e6) return '${trim(value / 1e6, 2)}M';
  if (value >= 1e3) return '${trim(value / 1e3, 1)}K';
  return trim(value, 0);
}

class HomeScreen extends ConsumerWidget {
  // Callback fourni par MainNavigationScreen pour basculer vers
  // l'onglet Menu (même pattern que CampaignsScreen.onOpenMenu).
  final VoidCallback onOpenMenu;

  const HomeScreen({super.key, required this.onOpenMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeDataProvider);
    final data = home.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _Header(
                  onOpenMenu: onOpenMenu,
                  unread: data?.summary?.unreadNotifications ?? 0,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.refresh(homeDataProvider.future),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                      child: home.when(
                        loading: () => const _HomeLoading(),
                        error: (error, _) => _HomeError(
                          message: error is AppException
                              ? error.message
                              : "Impossible de charger l'accueil.",
                          onRetry: () => ref.invalidate(homeDataProvider),
                        ),
                        data: (data) => _HomeContent(data: data, onOpenMenu: onOpenMenu),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(right: 16, bottom: 24, child: _AiFloatingButton()),
          ],
        ),
      ),
      // La Bottom Navigation est gérée par MainNavigationScreen.
    );
  }
}

// =============================================================
// EN-TÊTE
// =============================================================

class _Header extends StatelessWidget {
  final VoidCallback onOpenMenu;
  final int unread;

  const _Header({required this.onOpenMenu, required this.unread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 2)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onOpenMenu,
            tooltip: 'Menu',
            icon: const Icon(Icons.menu, size: 24, color: AppColors.black),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.gray100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    size: 22,
                    color: AppColors.black,
                    semanticLabel: unread > 0
                        ? '$unread notification${unread > 1 ? 's' : ''} non lue${unread > 1 ? 's' : ''}'
                        : 'Notifications',
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 18),
                      height: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6900),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: AppColors.gray100,
                child: Icon(Icons.person, color: AppColors.gray400, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CONTENU
// =============================================================

class _HomeContent extends StatelessWidget {
  final HomeData data;
  final VoidCallback onOpenMenu;

  const _HomeContent({required this.data, required this.onOpenMenu});

  @override
  Widget build(BuildContext context) {
    final summary = data.summary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour ${data.me.displayName} !',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Voici ce qui se passe aujourd'hui sur vos campagnes.",
          style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C)),
        ),
        const SizedBox(height: 20),
        if (summary == null)
          const _NoCompanyCard()
        else
          _OverviewCard(summary: summary),
        const SizedBox(height: 16),
        _QuickActions(onOpenMenu: onOpenMenu),
        if (summary != null && canSeeRecommendations(data.me.role)) ...[
          const SizedBox(height: 20),
          _AiRecommendationCard(
            campaign: data.focusCampaign,
            recommendation: data.recommendations.isNotEmpty ? data.recommendations.first : null,
          ),
        ],
      ],
    );
  }
}

BoxDecoration _cardDecoration({double blur = 6}) => BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: blur,
          offset: const Offset(0, 2),
        ),
      ],
    );

class _NoCompanyCard extends StatelessWidget {
  const _NoCompanyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: const Row(
        children: [
          Icon(Icons.business_outlined, color: AppColors.blue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Votre compte n'est rattaché à aucune entreprise. Créez-la sur kiyanza.com, "
              "ou demandez une invitation à votre administrateur, pour lancer vos campagnes.",
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final DashboardSummary summary;

  const _OverviewCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final running = summary.countOf(CampaignStatus.inProgress);
    final stats = [
      _StatTile(
        icon: Icons.campaign_outlined,
        color: AppColors.blue,
        label: 'Campagnes actives',
        value: '$running',
        detail: 'sur ${summary.totalCampaigns}',
      ),
      _StatTile(
        icon: Icons.account_balance_wallet_outlined,
        color: const Color(0xFFFF6A00),
        label: 'Budget prévu',
        value: formatCompactAmount(summary.totalPlannedBudget),
        suffix: 'FCFA',
      ),
      _StatTile(
        icon: Icons.payments_outlined,
        color: AppColors.green,
        label: 'Budget dépensé',
        value: formatCompactAmount(summary.totalActualBudget),
        suffix: 'FCFA',
      ),
      _StatTile(
        icon: Icons.radio_outlined,
        color: const Color(0xFF7C3AED),
        label: 'Diffusions conformes',
        value: '${(summary.complianceRate * 100).round()}%',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vue d'ensemble",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final double tileWidth = constraints.maxWidth < 380
                  ? (constraints.maxWidth - 8) / 2
                  : (constraints.maxWidth - 12) / 4;
              return Wrap(
                spacing: 4,
                runSpacing: 12,
                children: stats
                    .map((stat) => SizedBox(width: tileWidth, child: _StatTileView(stat: stat)))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatTileView extends StatelessWidget {
  final _StatTile stat;

  const _StatTileView({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: stat.color, shape: BoxShape.circle),
          child: Icon(stat.icon, size: 16, color: AppColors.white),
        ),
        const SizedBox(height: 4),
        Text(stat.label, style: const TextStyle(fontSize: 10, color: Color(0xFF99A1AF))),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              stat.value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            if (stat.suffix != null) ...[
              const SizedBox(width: 3),
              Text(stat.suffix!, style: const TextStyle(fontSize: 9, color: Color(0xFF99A1AF))),
            ],
          ],
        ),
        if (stat.detail != null) ...[
          const SizedBox(height: 2),
          Text(stat.detail!, style: const TextStyle(fontSize: 11, color: Color(0xFF99A1AF))),
        ],
      ],
    );
  }
}

// =============================================================
// ACTIONS RAPIDES
// =============================================================

class _QuickActions extends StatelessWidget {
  final VoidCallback onOpenMenu;

  const _QuickActions({required this.onOpenMenu});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.campaign_outlined,
        label: 'Campagnes',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CampaignsScreen(onOpenMenu: () => Navigator.pop(context)),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.monitor_heart_outlined,
        label: 'Monitoring',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MonitoringScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.auto_awesome_outlined,
        label: 'Assistant IA',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KiyanzaAiScreen()),
        ),
      ),
      _QuickAction(icon: Icons.more_horiz, label: 'Voir tout', onTap: onOpenMenu),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            const double spacing = 8;
            final bool useTwoColumns = constraints.maxWidth < 380;
            final double cardWidth = useTwoColumns
                ? (constraints.maxWidth - spacing) / 2
                : (constraints.maxWidth - spacing * 3) / 4;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: actions
                  .map((action) => SizedBox(width: cardWidth, child: _QuickActionCard(action: action)))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 22, color: const Color(0xFF364153)),
              const SizedBox(height: 4),
              Text(
                action.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF364153),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// RECOMMANDATION IA
// =============================================================

class _AiRecommendationCard extends StatelessWidget {
  final DashboardCampaignSummary? campaign;
  final RecommendationModel? recommendation;

  const _AiRecommendationCard({required this.campaign, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final reco = recommendation;
    final String headline;
    final String detail;
    if (campaign == null) {
      headline = 'Créez votre première campagne';
      detail = "L'IA vous conseillera à partir de ses paramètres, de sa simulation et de ses résultats.";
    } else if (reco == null) {
      headline = 'Aucune recommandation pour ${campaign!.name}';
      detail = "Demandez à l'IA des conseils fondés sur les données de la campagne.";
    } else {
      headline = reco.title ?? reco.content;
      detail = reco.title != null ? reco.content : 'Pour ${campaign!.name}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(blur: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: Color(0xFF155DFC)),
              const SizedBox(width: 8),
              const Text(
                'Recommandation IA',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF155DFC),
                ),
              ),
              const Spacer(),
              if (reco != null)
                Text(
                  recommendationPriorityLabel(reco.priority),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: reco.priority == RecommendationPriority.high
                        ? const Color(0xFFDC2626)
                        : AppColors.gray400,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            headline,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
          ),
          if (campaign != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                child: Text(
                  reco == null ? 'Obtenir des recommandations' : 'Voir les recommandations',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================
// CHARGEMENT ET ERREUR
// =============================================================

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    Widget block(double height) => Container(
          height: height,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(24),
          ),
        );
    return Semantics(
      label: "Chargement de l'accueil",
      child: Column(children: [block(56), block(150), block(72), block(160)]),
    );
  }
}

class _HomeError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _HomeError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40, color: AppColors.gray400),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray500)),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// BOUTON IA FLOTTANT
// =============================================================

class _AiFloatingButton extends StatelessWidget {
  const _AiFloatingButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Assistant IA',
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KiyanzaAiScreen()),
        ),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome, size: 20, color: AppColors.white),
        ),
      ),
    );
  }
}

// =============================================================
// MODÈLES D'AFFICHAGE
// =============================================================

class _StatTile {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String? suffix;
  final String? detail;

  const _StatTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.suffix,
    this.detail,
  });
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});
}
