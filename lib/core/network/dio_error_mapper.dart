import 'package:dio/dio.dart';
import 'app_exceptions.dart';

/// Traduit une erreur Dio d'une route protégée en [AppException] lisible
/// par l'utilisateur. Même règles que les datasources existantes : un 401
/// arrivé jusqu'ici veut dire que l'ApiClient a déjà tenté un refresh, donc
/// que la session est réellement terminée.
AppException mapDioError(DioException e) {
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
  if (status == 404) return const ResourceNotFoundException();
  if (status == 409) {
    return ConflictException(
        rawMessage?.toString() ?? 'Les données ont changé entre-temps, réessayez.');
  }
  if (status == 429) return const TooManyAttemptsException();
  if (status == 503) return const ServerUnavailableException();
  if (status == 400) {
    final details = rawMessage is List
        ? rawMessage.map((m) => m.toString()).toList()
        : [rawMessage?.toString() ?? 'Requête invalide.'];
    return ValidationFailedException(details);
  }
  return const UnknownServerException();
}
