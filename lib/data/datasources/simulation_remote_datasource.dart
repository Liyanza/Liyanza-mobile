import 'package:dio/dio.dart';
import '../models/simulation/simulation_models.dart';
import '../../core/network/app_exceptions.dart';

class SimulationRemoteDatasource {
  final Dio _dio;
  SimulationRemoteDatasource(this._dio);

  Future<List<SimulationQuestionModel>> getQuestions() async {
    try {
      final response = await _dio.get('/questionnaires-simulation/questions');
      return (response.data as List)
          .map((e) => SimulationQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<SimulationModel> submit(String campaignId, SubmitSimulationRequest request) async {
    try {
      final response = await _dio.post(
        '/campagnes/$campaignId/simulations',
        data: request.toJson(),
      );
      return SimulationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<SimulationModel>> getHistory(String campaignId) async {
    try {
      // Pas de wrapper {items,total,...} ici, contrairement à GET /campagnes
      // (guide campagnes, étape 3) — la doc API le précise explicitement
      // ("non paginé") : le backend renvoie un tableau JSON brut.
      final response = await _dio.get('/campagnes/$campaignId/simulations');
      return (response.data as List)
          .map((e) => SimulationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NoInternetException();
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;
    final rawMessage = data is Map ? data['message'] : null;

    if (status == 401) return const SessionExpiredException();
    if (status == 403) {
      return ForbiddenException(rawMessage?.toString() ??
          "Vous n'avez pas les droits nécessaires pour effectuer cette action.");
    }
    if (status == 404) return const ResourceNotFoundException('Campagne introuvable.');
    if (status == 400) {
      // Couvre à la fois les erreurs de validation classiques (tableau) et
      // la règle métier "Cannot simulate a completed or cancelled campaign."
      // (chaîne simple, simulations.service.ts).
      final details = rawMessage is List
          ? rawMessage.map((m) => m.toString()).toList()
          : [rawMessage?.toString() ?? 'Requête invalide.'];
      return ValidationFailedException(details);
    }
    // Couvre le 500 "Failed to get simulation results from AI engine..."
    // si le moteur mock échoue.
    return const UnknownServerException();
  }
}