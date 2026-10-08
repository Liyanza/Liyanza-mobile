import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/app_exceptions.dart';
import '../core/providers/campagne_providers.dart';
import '../core/providers/campaign_detail_providers.dart';
import '../core/providers/dashboard_providers.dart';
import '../core/theme/kiyanza_colors.dart';
import '../core/theme/kiyanza_sizes.dart';
import '../data/models/campagnes/campagne_models.dart';
import '../data/models/campagnes/campaign_detail_models.dart';
import '../data/models/dashboard/dashboard_models.dart';
import 'campagne.dart';

// =============================================================
// FORMATAGE
// =============================================================

const _months = [
  'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
  'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
];

String formatDay(DateTime date) {
  final d = date.toLocal();
  return '${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// 1234567.8 → « 1 234 568 ».
String formatInt(double value) {
  final str = value.round().abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (int i = 0; i < str.length; i++) {
    if (i != 0 && (str.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(str[i]);
  }
  return buffer.toString();
}

String formatFcfa(double value) => '${formatInt(value)} FCFA';

String formatPercent(double ratio) => '${(ratio * 100).round()} %';

/// Valeur d'un indicateur comparé (volume, taux en %, coût en FCFA).
String formatMetric(String kind, double? value) {
  if (value == null) return '—';
  return switch (kind) {
    'rate' => '${value.toStringAsFixed(1).replaceAll('.', ',')} %',
    'cost' => formatFcfa(value),
    _ => formatInt(value),
  };
}

/// Prochaine étape du cycle de vie, avec son libellé d'action.
(CampaignStatus, String)? nextTransition(CampaignStatus status) => switch (status) {
      CampaignStatus.draft => (CampaignStatus.planned, 'Valider la campagne'),
      CampaignStatus.planned => (CampaignStatus.inProgress, 'Démarrer la campagne'),
      CampaignStatus.inProgress => (CampaignStatus.completed, 'Terminer la campagne'),
      _ => null,
    };

Color _statusColor(CampaignStatus status) => switch (status) {
      CampaignStatus.inProgress => const Color(0xFF2AA147),
      CampaignStatus.planned => AppColors.blue,
      CampaignStatus.completed => AppColors.gray500,
      CampaignStatus.cancelled => const Color(0xFFDC2626),
      CampaignStatus.draft => AppColors.orange,
    };

// =============================================================
// ÉCRAN
// =============================================================

class CampaignDetailScreen extends ConsumerStatefulWidget {
  /// Carte de la liste : sert à afficher l'en-tête sans attendre le réseau.
  final CampaignItem campaign;

  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  ConsumerState<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends ConsumerState<CampaignDetailScreen> {
  bool _busy = false;

  String get _id => widget.campaign.id!;

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _errorText(Object error) {
    if (error is ValidationFailedException) return error.details.join('\n');
    if (error is AppException) return error.message;
    return 'Une erreur est survenue, réessayez.';
  }

  void _refreshEverywhere() {
    ref.invalidate(campaignDetailProvider(_id));
    ref.invalidate(homeDataProvider);
    ref.read(campagnesNotifierProvider.notifier).refresh();
  }

  Future<void> _transition(CampaignStatus status, {required String done}) async {
    setState(() => _busy = true);
    try {
      await ref.read(campaignDetailRemoteDatasourceProvider).transition(_id, status);
      _refreshEverywhere();
      if (mounted) _showSnack(done);
    } catch (e) {
      if (mounted) _showSnack(_errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Annuler la campagne ?'),
        content: const Text(
          'Ses diffusions prévues seront annulées. Cette action est définitive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Garder'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
            child: const Text('Annuler la campagne'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _transition(CampaignStatus.cancelled, done: 'Campagne annulée.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.campaign.id == null) {
      return const Scaffold(body: Center(child: Text('Campagne introuvable.')));
    }
    final detail = ref.watch(campaignDetailProvider(_id));
    final data = detail.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              canCancel: data != null &&
                  data.canManage &&
                  data.campaign.status != CampaignStatus.completed &&
                  data.campaign.status != CampaignStatus.cancelled,
              onCancel: _confirmCancel,
              onRefresh: () => ref.invalidate(campaignDetailProvider(_id)),
            ),
            _CampaignHeader(item: widget.campaign, campaign: data?.campaign),
            Expanded(
              child: detail.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _ErrorState(
                  message: _errorText(error),
                  onRetry: () => ref.invalidate(campaignDetailProvider(_id)),
                ),
                data: (data) => _DetailTabs(
                  data: data,
                  onRecommendationsChanged: () => ref.invalidate(campaignDetailProvider(_id)),
                ),
              ),
            ),
            if (data != null && data.canManage && nextTransition(data.campaign.status) != null)
              _ActionBar(
                label: nextTransition(data.campaign.status)!.$2,
                busy: _busy,
                onPressed: () {
                  final (status, label) = nextTransition(data.campaign.status)!;
                  _transition(status, done: '$label : c\'est fait.');
                },
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// EN-TÊTES
// =============================================================

class _Header extends StatelessWidget {
  final bool canCancel;
  final VoidCallback onCancel;
  final VoidCallback onRefresh;

  const _Header({required this.canCancel, required this.onCancel, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Retour',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.black),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Détail campagne',
                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Actions',
            icon: const Icon(Icons.more_vert, size: 20, color: AppColors.black),
            onSelected: (value) => value == 'cancel' ? onCancel() : onRefresh(),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'refresh', child: Text('Actualiser')),
              if (canCancel)
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Annuler la campagne', style: TextStyle(color: Color(0xFFDC2626))),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignHeader extends StatelessWidget {
  final CampaignItem item;
  final CampagneModel? campaign;

  const _CampaignHeader({required this.item, this.campaign});

  @override
  Widget build(BuildContext context) {
    final status = campaign?.status;
    final statusLabel = status != null ? campaignStatusLabel(status) : item.status;
    final statusColor = status != null ? _statusColor(status) : const Color(0xFF2AA147);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, size: 24, color: item.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        campaign?.name ?? item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor, width: 1.2),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.platform, style: const TextStyle(fontSize: 12, color: AppColors.gray400)),
                if (campaign != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${formatDay(campaign!.startDate)} — ${formatDay(campaign!.endDate)}',
                    style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// ONGLETS
// =============================================================

class _DetailTabs extends StatelessWidget {
  final CampaignDetailData data;
  final VoidCallback onRecommendationsChanged;

  const _DetailTabs({required this.data, required this.onRecommendationsChanged});

  @override
  Widget build(BuildContext context) {
    final isDigital = data.campaign.type == CampaignType.digital;
    final tabs = <(String, Widget)>[
      ('Aperçu', _OverviewTab(data: data)),
      ('Résultats', _ResultsTab(data: data)),
      if (isDigital) ('Audience', _AudienceTab(digital: data.digital)),
      if (data.recommendations != null)
        (
          'Conseils IA',
          _RecommendationsTab(
            campaignId: data.campaign.id,
            recommendations: data.recommendations!,
            onChanged: onRecommendationsChanged,
          ),
        ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: tabs.length > 3,
            labelColor: AppColors.black,
            unselectedLabelColor: AppColors.gray400,
            indicatorColor: AppColors.green,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: [for (final tab in tabs) Tab(text: tab.$1)],
          ),
          Expanded(
            child: TabBarView(children: [for (final tab in tabs) tab.$2]),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;

  const _Section({required this.title, required this.child, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.black)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.gray500))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _Progress({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray500))),
              Text(formatPercent(value), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clamped.toDouble(),
              minHeight: 6,
              backgroundColor: AppColors.gray100,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Empty({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.gray400),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Aperçu

class _OverviewTab extends StatelessWidget {
  final CampaignDetailData data;

  const _OverviewTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = data.campaign;
    final now = DateTime.now();
    final totalDays = c.endDate.difference(c.startDate).inDays.clamp(1, 100000);
    final elapsed = now.isBefore(c.startDate)
        ? 0.0
        : (now.difference(c.startDate).inDays / totalDays).clamp(0.0, 1.0);
    final spent = data.actual?.spendXaf ?? c.actualBudget;
    final digital = data.digital;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _Section(
          title: 'Budget et calendrier',
          child: Column(
            children: [
              _InfoRow('Budget prévu', formatFcfa(c.plannedBudget)),
              _InfoRow('Dépensé', spent > 0 ? formatFcfa(spent) : '—'),
              if (c.plannedBudget > 0 && spent > 0)
                _Progress(label: 'Budget utilisé', value: spent / c.plannedBudget, color: AppColors.orange),
              _Progress(label: 'Durée écoulée', value: elapsed, color: AppColors.blue),
              _InfoRow('Durée', '$totalDays jours'),
            ],
          ),
        ),
        _Section(
          title: 'Objectif',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.objective, style: const TextStyle(fontSize: 13, color: AppColors.black, height: 1.4)),
              if (digital != null) ...[
                const SizedBox(height: 10),
                _InfoRow('Optimisation', digitalObjectiveLabel(digital.objective)),
                if (digital.customObjective != null) _InfoRow('Objectif précis', digital.customObjective!),
                if (digital.platforms.isNotEmpty)
                  _InfoRow('Canaux', digital.platforms.map(platformLabel).join(', ')),
                _InfoRow('Budget', digital.budgetAllocation == 'DAILY' ? 'Journalier' : 'Total'),
              ],
            ],
          ),
        ),
        _Section(
          title: 'Responsable',
          child: _InfoRow(
            'Créée par',
            '${c.launchedBy.firstName} ${c.launchedBy.lastName}'.trim(),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Résultats

class _ResultsTab extends StatelessWidget {
  final CampaignDetailData data;

  const _ResultsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    final c = data.campaign;

    if (c.type == CampaignType.radio) {
      final report = data.conformity;
      children.add(_Section(
        title: 'Conformité des diffusions',
        child: report == null || report.total == 0
            ? const _Empty(icon: Icons.radio_outlined, text: 'Aucune diffusion planifiée pour cette campagne.')
            : Column(
                children: [
                  if (report.rate != null)
                    _Progress(label: 'Diffusions conformes', value: report.rate!, color: AppColors.green),
                  _InfoRow('Prévues', '${report.total}'),
                  _InfoRow('Diffusées', '${report.broadcasted}', valueColor: const Color(0xFF2AA147)),
                  _InfoRow('Manquées', '${report.missed}',
                      valueColor: report.missed > 0 ? const Color(0xFFDC2626) : null),
                  _InfoRow('À venir', '${report.pending}'),
                  if (report.cancelled > 0) _InfoRow('Annulées', '${report.cancelled}'),
                ],
              ),
      ));
    }

    if (c.type == CampaignType.digital) {
      final actual = data.actual;
      if (actual != null) {
        children.add(_Section(
          title: 'Résultats réels',
          subtitle: actual.metaCampaignName != null
              ? 'Facebook Ads · ${actual.metaCampaignName}'
              : 'Facebook Ads',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (actual.spendProgress != null)
                _Progress(label: 'Budget dépensé', value: actual.spendProgress!, color: AppColors.orange),
              _Progress(label: 'Durée écoulée', value: actual.timeProgress, color: AppColors.blue),
              if (actual.tooEarly)
                const Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    'Campagne trop récente : les écarts avec la prévision ne sont pas encore significatifs.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.gray500),
                  ),
                ),
              if (actual.openAlerts > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${actual.openAlerts} alerte${actual.openAlerts > 1 ? 's' : ''} ouverte${actual.openAlerts > 1 ? 's' : ''} : détails et actions recommandées sur kiyanza.com.',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFDC2626), fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(height: 4),
              for (final m in actual.metrics) _MetricRow(metric: m),
            ],
          ),
        ));
      }

      final sim = data.simulation;
      if (sim != null) {
        children.add(_Section(
          title: 'Prévision',
          subtitle: 'Simulation du ${formatDay(sim.simulatedAt)} · scénario ${scenarioStrategyLabel(sim.recommendedStrategy).toLowerCase()}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sim.predictedReach != null) _InfoRow('Personnes touchées', formatInt(sim.predictedReach!)),
              if (sim.predictedClicks != null) _InfoRow('Clics', formatInt(sim.predictedClicks!)),
              if (sim.predictedConversions != null) _InfoRow('Résultats', formatInt(sim.predictedConversions!)),
              if (sim.predictedCtr != null) _InfoRow('Taux de clic', formatMetric('rate', sim.predictedCtr)),
              if (sim.avgCpc != null) _InfoRow('Coût par clic', formatFcfa(sim.avgCpc!)),
              if (sim.costPerAcquisition != null) _InfoRow('Coût par résultat', formatFcfa(sim.costPerAcquisition!)),
              if (sim.summary != null) ...[
                const SizedBox(height: 10),
                Text(sim.summary!, style: const TextStyle(fontSize: 12.5, color: AppColors.gray600, height: 1.45)),
              ],
            ],
          ),
        ));
      }

      if (actual == null && sim == null) {
        children.add(const _Section(
          title: 'Résultats',
          child: _Empty(
            icon: Icons.insights_outlined,
            text: 'Aucune simulation ni campagne Facebook Ads reliée pour le moment.\n'
                'Lancez une simulation ou reliez votre campagne Facebook Ads sur kiyanza.com.',
          ),
        ));
      } else if (actual == null) {
        children.add(const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: Text(
            'Reliez la campagne Facebook Ads sur kiyanza.com pour comparer la prévision aux résultats réels.',
            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),
        ));
      }
    }

    if (c.type == CampaignType.poster) {
      children.add(const _Section(
        title: 'Suivi terrain',
        child: _Empty(
          icon: Icons.place_outlined,
          text: 'Le suivi des emplacements et des preuves photo se fait depuis l\'onglet Terrain de kiyanza.com.',
        ),
      ));
    }

    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: children);
  }
}

class _MetricRow extends StatelessWidget {
  final MetricComparisonModel metric;

  const _MetricRow({required this.metric});

  @override
  Widget build(BuildContext context) {
    final color = switch (metric.status) {
      MetricStatus.ahead => const Color(0xFF2AA147),
      MetricStatus.onTrack => AppColors.blue,
      MetricStatus.behind => const Color(0xFFDC2626),
      MetricStatus.unknown => AppColors.gray400,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metricLabel(metric.key), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                Text(
                  'Prévu à ce stade : ${formatMetric(metric.kind, metric.expected)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.gray400),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatMetric(metric.kind, metric.actual), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Text(metricStatusLabel(metric.status), style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- Audience

class _AudienceTab extends StatelessWidget {
  final DigitalDetailsModel? digital;

  const _AudienceTab({required this.digital});

  @override
  Widget build(BuildContext context) {
    final d = digital;
    if (d == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Empty(icon: Icons.groups_outlined, text: "L'audience de cette campagne n'a pas encore été définie."),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _Section(
          title: 'Cible',
          child: Column(
            children: [
              _InfoRow('Âge', '${d.ageMin} – ${d.ageMax} ans'),
              _InfoRow('Sexe', targetGenderLabel(d.targetGender)),
            ],
          ),
        ),
        _Section(
          title: 'Zones géographiques',
          child: d.locations.isEmpty
              ? const Text('Aucune zone précisée.', style: TextStyle(fontSize: 12.5, color: AppColors.gray500))
              : _Chips(values: d.locations),
        ),
        _Section(
          title: "Centres d'intérêt",
          child: d.interests.isEmpty
              ? const Text("Aucun centre d'intérêt précisé.", style: TextStyle(fontSize: 12.5, color: AppColors.gray500))
              : _Chips(values: d.interests),
        ),
      ],
    );
  }
}

class _Chips extends StatelessWidget {
  final List<String> values;

  const _Chips({required this.values});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final value in values)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(value, style: const TextStyle(fontSize: 12, color: AppColors.gray700)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Conseils IA

class _RecommendationsTab extends ConsumerStatefulWidget {
  final String campaignId;
  final List<RecommendationModel> recommendations;
  final VoidCallback onChanged;

  const _RecommendationsTab({
    required this.campaignId,
    required this.recommendations,
    required this.onChanged,
  });

  @override
  ConsumerState<_RecommendationsTab> createState() => _RecommendationsTabState();
}

class _RecommendationsTabState extends ConsumerState<_RecommendationsTab> {
  bool _generating = false;
  String? _error;

  Future<void> _generate() async {
    setState(() {
      _generating = true;
      _error = null;
    });
    try {
      await ref.read(dashboardRemoteDatasourceProvider).generateRecommendations(widget.campaignId);
      ref.invalidate(homeDataProvider);
      widget.onChanged();
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recos = widget.recommendations;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        if (_generating)
          const _Empty(
            icon: Icons.auto_awesome,
            text: "L'IA analyse votre campagne : paramètres, simulation, résultats réels, alertes, radio et terrain…",
          )
        else if (recos.isEmpty)
          const _Empty(
            icon: Icons.lightbulb_outline,
            text: "Aucune recommandation pour cette campagne. Demandez des conseils à l'IA.",
          )
        else
          for (final reco in recos) _RecommendationCard(reco: reco),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(_error!, style: const TextStyle(fontSize: 12.5, color: Color(0xFFDC2626))),
          ),
        const SizedBox(height: 4),
        SizedBox(
          height: 46,
          child: ElevatedButton.icon(
            onPressed: _generating ? null : _generate,
            icon: _generating
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                : Icon(recos.isEmpty ? Icons.auto_awesome : Icons.refresh, size: 18),
            label: Text(recos.isEmpty ? 'Générer des recommandations' : 'Actualiser les recommandations'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: AppColors.white,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final RecommendationModel reco;

  const _RecommendationCard({required this.reco});

  @override
  Widget build(BuildContext context) {
    final (bar, badgeBg, badgeFg) = switch (reco.priority) {
      RecommendationPriority.high => (const Color(0xFFEF4444), const Color(0x1ADC2626), const Color(0xFFDC2626)),
      RecommendationPriority.medium => (const Color(0xFFFB923C), const Color(0x1AF97316), const Color(0xFFEA580C)),
      RecommendationPriority.low => (const Color(0xFFCBD5E1), AppColors.gray100, AppColors.gray500),
    };
    final category = recommendationCategoryLabel(reco.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: bar,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Badge(text: recommendationPriorityLabel(reco.priority), bg: badgeBg, fg: badgeFg),
                        if (category != null) _Badge(text: category, bg: AppColors.gray100, fg: AppColors.gray600),
                      ],
                    ),
                    if (reco.title != null) ...[
                      const SizedBox(height: 8),
                      Text(reco.title!, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    ],
                    const SizedBox(height: 4),
                    Text(reco.content, style: const TextStyle(fontSize: 12.5, color: AppColors.gray600, height: 1.45)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

// =============================================================
// ÉTATS ET ACTION
// =============================================================

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

class _ActionBar extends StatelessWidget {
  final String label;
  final bool busy;
  final VoidCallback onPressed;

  const _ActionBar({required this.label, required this.busy, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.gray100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: busy ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: busy
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
              : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
