import 'package:dio/dio.dart';
import '../models/monitoring/monitoring_models.dart';
import '../../core/network/dio_error_mapper.dart';

/// Suivi opérationnel : diffusions radio, terrain, tâches et équipe.
class MonitoringRemoteDatasource {
  final Dio _dio;

  MonitoringRemoteDatasource(this._dio);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// Diffusions d'une campagne, par ordre chronologique (100 au plus).
  Future<List<BroadcastModel>> broadcasts(String campaignId) => _guard(() async {
        final response = await _dio.get('/campagnes/$campaignId/planning', queryParameters: {'page': 1, 'limit': 100});
        return itemsOf(response.data).map(BroadcastModel.fromJson).toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      });

  /// Constate qu'une diffusion a bien eu lieu, à l'heure indiquée.
  Future<void> recordBroadcast(String broadcastId, DateTime at) => _guard(() async {
        await _dio.patch('/diffusions/$broadcastId/constat', data: {
          'actualBroadcastAt': at.toUtc().toIso8601String(),
        });
      });

  Future<List<InstallationModel>> installations() => _guard(() async {
        final response = await _dio.get('/prestations');
        return itemsOf(response.data).map(InstallationModel.fromJson).toList();
      });

  /// Valide ou refuse la preuve photo d'une installation.
  Future<void> reviewProof(String installationId, {required bool validate, String? comment}) => _guard(() async {
        await _dio.patch('/prestations/$installationId/preuve/validation', data: {
          'decision': validate ? 'VALIDATED' : 'REJECTED',
          if (comment != null && comment.trim().isNotEmpty) 'comment': comment.trim(),
        });
      });

  Future<List<TaskModel>> tasks() => _guard(() async {
        final response = await _dio.get('/tasks', queryParameters: {'page': 1, 'limit': 100});
        return itemsOf(response.data).map(TaskModel.fromJson).toList();
      });

  Future<void> setTaskStatus(String taskId, TaskStatus status) => _guard(() async {
        await _dio.patch('/tasks/$taskId/statut', data: {'status': taskStatusToJson(status)});
      });

  /// Membres de l'entreprise (administrateur uniquement).
  Future<List<MemberModel>> members() => _guard(() async {
        final response = await _dio.get('/users');
        return itemsOf(response.data).map(MemberModel.fromJson).toList();
      });
}
