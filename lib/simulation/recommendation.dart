import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/app_exceptions.dart';
import '../core/providers/campagne_providers.dart';
import '../core/providers/dashboard_providers.dart';
import '../core/theme/kiyanza_colors.dart';
import '../core/widget/recommendation_card.dart';
import '../data/models/campagnes/campagne_models.dart';
import '../data/models/dashboard/dashboard_models.dart';

/// Recommandations IA d'une campagne (même contenu que la page
/// Recommandations du site). Ouvre la campagne en cours par défaut.
class RecommendationsScreen extends ConsumerStatefulWidget {
  final String? initialCampaignId;

  /// false quand l'écran est un onglet de la barre du bas (pas de retour).
  final bool showBack;

  const RecommendationsScreen({super.key, this.initialCampaignId, this.showBack = true});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  String? _campaignId;
  List<RecommendationModel> _recommendations = const [];
  bool _loading = false;
  bool _generating = false;
  String? _error;

  void _ensureSelection(List<CampagneModel> campaigns) {
    if (_campaignId != null || campaigns.isEmpty) return;
    final requested = campaigns.where((c) => c.id == widget.initialCampaignId);
    final running = campaigns.where((c) => c.status == CampaignStatus.inProgress);
    final initial = requested.isNotEmpty
        ? requested.first
        : (running.isNotEmpty ? running.first : campaigns.first);
    _campaignId = initial.id;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(initial.id));
  }

  Future<void> _load(String campaignId) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final recos = await ref.read(dashboardRemoteDatasourceProvider).recommendations(campaignId);
      if (mounted && _campaignId == campaignId) setState(() => _recommendations = recos);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _generate() async {
    final campaignId = _campaignId;
    if (campaignId == null) return;
    setState(() {
      _generating = true;
      _error = null;
    });
    try {
      final recos = await ref.read(dashboardRemoteDatasourceProvider).generateRecommendations(campaignId);
      ref.invalidate(homeDataProvider);
      if (mounted && _campaignId == campaignId) setState(() => _recommendations = recos);
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  void _select(String? campaignId) {
    if (campaignId == null || campaignId == _campaignId) return;
    setState(() {
      _campaignId = campaignId;
      _recommendations = const [];
    });
    _load(campaignId);
  }

  @override
  Widget build(BuildContext context) {
    final campaignsState = ref.watch(campagnesNotifierProvider);
    final campaigns = campaignsState.items;
    _ensureSelection(campaigns);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildBody(campaignsState, campaigns)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2)),
      ),
      child: Row(
        children: [
          if (widget.showBack)
            IconButton(
              tooltip: 'Retour',
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.black),
            )
          else
            const SizedBox(width: 48),
          const Expanded(
            child: Center(
              child: Text(
                'Recommandations IA',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildBody(CampagnesState state, List<CampagneModel> campaigns) {
    if (state.status == CampagnesStatus.loading || state.status == CampagnesStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CampagnesStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.errorMessage ?? 'Impossible de charger vos campagnes.',
                textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray500)),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref.read(campagnesNotifierProvider.notifier).refresh(),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    if (campaigns.isEmpty) {
      return const _Message(
        icon: Icons.campaign_outlined,
        text: "Vous n'avez pas encore de campagne. Créez-en une pour recevoir des recommandations.",
      );
    }

    return RefreshIndicator(
      onRefresh: () => _campaignId == null ? Future.value() : _load(_campaignId!),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text('CAMPAGNE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gray400, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _campaignId,
            isExpanded: true,
            onChanged: (_generating || _loading) ? null : _select,
            items: [
              for (final c in campaigns)
                DropdownMenuItem(
                  value: c.id,
                  child: Text('${c.name} · ${campaignStatusLabel(c.status)}', overflow: TextOverflow.ellipsis),
                ),
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(height: 18),
          if (_generating)
            const _Message(
              icon: Icons.auto_awesome,
              text: "L'IA analyse votre campagne : paramètres, simulation, résultats réels, alertes, radio et terrain…",
            )
          else if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_recommendations.isEmpty)
            const _Message(
              icon: Icons.lightbulb_outline,
              text: "Aucune recommandation pour cette campagne. Demandez des conseils à l'IA.",
            )
          else ...[
            for (final reco in _recommendations) RecommendationCard(reco: reco),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "Rédigées par l'IA à partir des données de la campagne. Actualisez-les quand la campagne évolue.",
                style: TextStyle(fontSize: 11, color: AppColors.gray400, height: 1.4),
              ),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(_error!, style: const TextStyle(fontSize: 12.5, color: Color(0xFFDC2626))),
            ),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: (_generating || _loading || _campaignId == null) ? null : _generate,
              icon: _generating
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                  : Icon(_recommendations.isEmpty ? Icons.auto_awesome : Icons.refresh, size: 18),
              label: Text(_recommendations.isEmpty ? 'Générer des recommandations' : 'Actualiser les recommandations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 34, color: AppColors.gray400),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4)),
        ],
      ),
    );
  }
}
