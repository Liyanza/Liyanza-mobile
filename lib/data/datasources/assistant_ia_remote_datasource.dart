import 'package:dio/dio.dart';
import '../models/assistant_ia/assistant_ia_models.dart';
import '../../core/network/app_exceptions.dart';

class AssistantIaRemoteDatasource {
  // Même raisonnement que CampagneRemoteDatasource (guide campagnes, étape
  // 5) : routes protégées, on réutilise le Dio de l'ApiClient existant
  // (Bearer token + refresh automatique déjà gérés).
  final Dio _dio;

  AssistantIaRemoteDatasource(this._dio);

  Future<AiConversationModel> createConversation(String topic) async {
    try {
      final response = await _dio.post('/conversations', data: {'topic': topic});
      return AiConversationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<SendMessageResult> sendMessage(String conversationId, String content) async {
    try {
      // Appel synchrone côté backend (doc API §13) : peut prendre plusieurs
      // secondes selon le moteur IA branché. Le timeout de 30s de l'ApiClient
      // (receiveTimeout, guide auth étape 8) doit suffire pour le mock
      // actuel ; à surveiller le jour où un vrai moteur (plus lent) sera
      // branché côté serveur.
      final response = await _dio.post(
        '/conversations/$conversationId/messages',
        data: {'content': content},
      );
      return SendMessageResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<AiConversationModel> getConversation(String conversationId) async {
    try {
      final response = await _dio.get('/conversations/$conversationId');
      return AiConversationModel.fromJson(response.data as Map<String, dynamic>);
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
    // 404 couvre à la fois "conversation inexistante" et "conversation
    // d'une autre entreprise" (assertSameCompany, voir étape 1).
    if (status == 404) return const ResourceNotFoundException("Conversation introuvable.");
    if (status == 429) return const TooManyAttemptsException();
    if (status == 400) {
      final details = rawMessage is List
          ? rawMessage.map((m) => m.toString()).toList()
          : [rawMessage?.toString() ?? 'Requête invalide.'];
      return ValidationFailedException(details);
    }
    // Couvre notamment le 500 "Failed to get response from AI engine"
    // (assistant-ia.service.ts) si le moteur IA échoue.
    return const UnknownServerException();
  }
}