import 'package:dio/dio.dart';
import '../models/auth/auth_models.dart';
import '../../core/network/app_exceptions.dart';

class AuthRemoteDatasource {
  // Instance Dio DÉDIÉE, volontairement séparée de l'ApiClient principal
  // (étape 8) : ces appels ne doivent jamais passer par l'intercepteur qui
  // injecte le Bearer token / déclenche un refresh — ce serait soit inutile
  // (register/login), soit une boucle infinie (refresh lui-même).
  final Dio _dio;

  AuthRemoteDatasource(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ));

  Future<AuthTokensResponse> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return AuthTokensResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapAuthError(e);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
      });
    } on DioException catch (e) {
      throw _mapAuthError(e);
    }
  }

  /// Utilisé par l'intercepteur de refresh (étape 8) — jamais appelé
  /// directement par l'UI.
  Future<AuthTokensResponse> refresh(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
      });
      return AuthTokensResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapAuthError(e);
    }
  }

  Future<void> logout({required String accessToken, String? refreshToken}) async {
    try {
      await _dio.post(
        '/auth/logout',
        data: refreshToken != null ? {'refreshToken': refreshToken} : {},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException {
      // Best-effort : même si l'appel réseau échoue (token déjà expiré,
      // pas de réseau...), on nettoie le stockage local dans tous les cas
      // côté repository (étape 9). Ne jamais bloquer une déconnexion.
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw _mapAuthError(e);
    }
  }

  AppException _mapAuthError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NoInternetException();
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;
    final rawMessage = data is Map ? data['message'] : null;

    if (status == 401) return const InvalidCredentialsException();
    if (status == 409) return const EmailAlreadyUsedException();
    if (status == 429) return const TooManyAttemptsException();
    if (status == 400) {
      final details = rawMessage is List
          ? rawMessage.map((m) => m.toString()).toList()
          : [rawMessage?.toString() ?? 'Requête invalide.'];
      return ValidationFailedException(details);
    }
    return const UnknownServerException();
  }
}