import 'package:dio/dio.dart';
import '../models/campagnes/campagne_models.dart';
import '../models/campagnes/campaign_detail_models.dart';
import '../../core/network/dio_error_mapper.dart';

/// Routes du détail d'une campagne (toutes protégées : Dio de l'ApiClient).
class CampaignDetailRemoteDatasource {
  final Dio _dio;

  CampaignDetailRemoteDatasource(this._dio);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// null si les paramètres digitaux n'ont pas encore été saisis (404).
  Future<DigitalDetailsModel?> digitalDetails(String campaignId) => _guard(() async {
        try {
          final response = await _dio.get('/campagnes/$campaignId/digital-details');
          return DigitalDetailsModel.fromJson(response.data as Map<String, dynamic>);
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) return null;
          rethrow;
        }
      });

  /// Simulation la plus récente, ou null.
  Future<SimulationSummaryModel?> latestSimulation(String campaignId) => _guard(() async {
        final response = await _dio.get(
          '/campagnes/$campaignId/simulations-digitales',
          queryParameters: {'page': 1, 'limit': 1},
        );
        final items = (response.data as Map<String, dynamic>)['items'] as List? ?? const [];
        return items.isEmpty ? null : SimulationSummaryModel.fromJson(items.first as Map<String, dynamic>);
      });

  /// null si aucune campagne Facebook Ads n'est reliée.
  Future<ActualPerformanceModel?> actualPerformance(String campaignId) => _guard(() async {
        final response = await _dio.get('/campagnes/$campaignId/performance-reelle');
        return ActualPerformanceModel.fromResponse(response.data as Map<String, dynamic>);
      });

  Future<ConformityReportModel> conformityReport(String campaignId) => _guard(() async {
        final response = await _dio.get('/campagnes/$campaignId/rapport-conformite');
        return ConformityReportModel.fromJson(response.data as Map<String, dynamic>);
      });

  /// Change le statut (DRAFT → PLANNED → IN_PROGRESS → COMPLETED, ou CANCELLED).
  Future<void> transition(String campaignId, CampaignStatus status) => _guard(() async {
        await _dio.post(
          '/campagnes/$campaignId/lancer',
          data: {'status': campaignStatusToJson(status)},
        );
      });
}
