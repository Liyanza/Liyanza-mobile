import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/models/auth/auth_models.dart';
import '../../data/models/campagnes/campagne_models.dart';
import '../../data/models/dashboard/dashboard_models.dart';

final dashboardRemoteDatasourceProvider = Provider(
  (ref) => DashboardRemoteDatasource(ref.read(apiClientProvider).dio),
);

/// Utilisateur connecté (prénom, rôle, entreprise).
final meProvider = FutureProvider.autoDispose<MeModel>(
  (ref) => ref.read(dashboardRemoteDatasourceProvider).me(),
);

/// Les recommandations IA ne sont ouvertes qu'à ces rôles côté backend.
bool canSeeRecommendations(UserRole role) =>
    role == UserRole.admin || role == UserRole.marketingManager;

class HomeData {
  final MeModel me;

  /// null tant que l'utilisateur n'a pas d'entreprise.
  final DashboardSummary? summary;

  /// Campagne suivie en priorité : la première en cours, sinon la plus récente.
  final DashboardCampaignSummary? focusCampaign;
  final List<RecommendationModel> recommendations;

  const HomeData({
    required this.me,
    this.summary,
    this.focusCampaign,
    this.recommendations = const [],
  });
}

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final datasource = ref.read(dashboardRemoteDatasourceProvider);
  final me = await ref.watch(meProvider.future);
  if (!me.hasCompany) return HomeData(me: me);

  final summary = await datasource.summary();
  final campaigns = summary.campaigns;
  final running = campaigns.where((c) => c.status == CampaignStatus.inProgress);
  final focus = running.isNotEmpty
      ? running.first
      : (campaigns.isNotEmpty ? campaigns.first : null);

  var recommendations = const <RecommendationModel>[];
  if (focus != null && canSeeRecommendations(me.role)) {
    try {
      recommendations = await datasource.recommendations(focus.id);
    } catch (_) {
      // Les recommandations sont un plus : leur échec ne bloque pas l'accueil.
    }
  }

  return HomeData(
    me: me,
    summary: summary,
    focusCampaign: focus,
    recommendations: recommendations,
  );
});
