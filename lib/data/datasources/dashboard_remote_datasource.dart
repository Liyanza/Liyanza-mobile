import 'package:dio/dio.dart';
import '../models/dashboard/dashboard_models.dart';
import '../../core/network/dio_error_mapper.dart';

/// Routes protégées de l'accueil : réutilise le Dio de l'ApiClient (Bearer
/// token et refresh automatique), comme CampagneRemoteDatasource.
class DashboardRemoteDatasource {
  final Dio _dio;

  DashboardRemoteDatasource(this._dio);

  Future<MeModel> me() async {
    try {
      final response = await _dio.get('/auth/me');
      return MeModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Réservé aux utilisateurs rattachés à une entreprise (403 sinon).
  Future<DashboardSummary> summary() async {
    try {
      final response = await _dio.get('/dashboard');
      return DashboardSummary.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Triées de la plus à la moins urgente par le backend.
  Future<List<RecommendationModel>> recommendations(String campaignId) async {
    try {
      final response = await _dio.get('/campagnes/$campaignId/recommandations');
      return (response.data as List)
          .map((r) => RecommendationModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Demande à l'IA de nouvelles recommandations (15 à 30 s).
  Future<List<RecommendationModel>> generateRecommendations(String campaignId) async {
    try {
      final response = await _dio.post(
        '/campagnes/$campaignId/recommandations/generer',
        options: Options(receiveTimeout: const Duration(seconds: 90)),
      );
      return (response.data as List)
          .map((r) => RecommendationModel.fromJson(r as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
