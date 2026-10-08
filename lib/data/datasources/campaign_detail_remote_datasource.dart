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

  /// Paramètres digitaux de la campagne (objectif, audience, type de budget).
  Future<void> upsertDigitalDetails(
    String campaignId, {
    required String objective,
    required int ageMin,
    required int ageMax,
    required String gender,
    required List<String> locations,
    required List<String> interests,
    String budgetAllocation = 'TOTAL',
  }) =>
      _guard(() async {
        await _dio.put('/campagnes/$campaignId/digital-details', data: {
          'objective': objective,
          'ageMin': ageMin,
          'ageMax': ageMax,
          'targetGender': gender,
          'targetLocations': locations,
          'targetInterests': interests,
          'budgetAllocation': budgetAllocation,
        });
      });

  /// Canaux de diffusion ; le compte social se relie ensuite sur le site.
  Future<void> selectChannels(String campaignId, List<String> platforms) => _guard(() async {
        await _dio.put('/campagnes/$campaignId/digital-details/channels', data: {
          'channels': [
            for (final platform in platforms) {'platform': platform},
          ],
        });
      });

  /// Lance une simulation (références de marché si aucun compte n'est relié).
  Future<void> runSimulation(String campaignId) => _guard(() async {
        await _dio.post(
          '/campagnes/$campaignId/simulations-digitales',
          options: Options(receiveTimeout: const Duration(seconds: 90)),
        );
      });

  /// Change le statut (DRAFT → PLANNED → IN_PROGRESS → COMPLETED, ou CANCELLED).
  Future<void> transition(String campaignId, CampaignStatus status) => _guard(() async {
        await _dio.post(
          '/campagnes/$campaignId/lancer',
          data: {'status': campaignStatusToJson(status)},
        );
      });
}
