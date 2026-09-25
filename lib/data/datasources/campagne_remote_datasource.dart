import 'package:dio/dio.dart';
import '../models/campagnes/campagne_models.dart';
import '../../core/network/app_exceptions.dart';

class CampagneRemoteDatasource {
  // Contrairement à AuthRemoteDatasource (guide auth, étape 6), ces routes
  // sont TOUTES protégées par JwtAuthGuard : on réutilise volontairement le
  // Dio de l'ApiClient existant (guide auth, étape 8), qui injecte déjà le
  // Bearer token sur chaque requête et déclenche le refresh automatique en
  // cas de 401. Pas de nouvelle instance Dio ici, contrairement à l'auth.
  final Dio _dio;

  CampagneRemoteDatasource(this._dio);

  Future<CampagnesPage> list({
    int page = 1,
    int limit = 10,
    CampaignStatus? status,
    CampaignType? type,
  }) async {
    try {
      final response = await _dio.get('/campagnes', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': campaignStatusToJson(status),
        if (type != null) 'type': campaignTypeToJson(type),
      });
      return CampagnesPage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapCampagneError(e);
    }
  }

  Future<CampagneModel> create(CreateCampagneRequest request) async {
    try {
      final response = await _dio.post('/campagnes', data: request.toJson());
      return CampagneModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapCampagneError(e);
    }
  }

  Future<CampagneModel> getById(String id) async {
    try {
      final response = await _dio.get('/campagnes/$id');
      return CampagneModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapCampagneError(e);
    }
  }

  AppException _mapCampagneError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NoInternetException();
    }

    final status = e.response?.statusCode;
    final data = e.response?.data;
    final rawMessage = data is Map ? data['message'] : null;

    // Un 401 arrivant JUSQU'ICI signifie que l'intercepteur de l'ApiClient a
    // déjà tenté un refresh et qu'il a échoué (refresh token expiré/invalide)
    // — voir onError dans api_client.dart. Ce n'est donc jamais un 401 "brut",
    // c'est une session réellement terminée.
    if (status == 401) return const SessionExpiredException();
    if (status == 403) {
      return ForbiddenException(rawMessage?.toString() ??
          "Vous n'avez pas les droits nécessaires pour effectuer cette action.");
    }
    if (status == 404) return const ResourceNotFoundException();
    if (status == 409) {
      return ConflictException(rawMessage?.toString() ??
          'Les données ont changé entre-temps, réessayez.');
    }
    if (status == 429) return const TooManyAttemptsException();
    if (status == 400) {
      // BadRequestException (règle métier : dates invalides, budget <= 0...)
      // renvoie un message simple ; les erreurs de validation class-validator
      // (champ manquant) renvoient un tableau — les deux formats existent
      // réellement côté backend selon le cas, voir campagnes.service.ts.
      final details = rawMessage is List
          ? rawMessage.map((m) => m.toString()).toList()
          : [rawMessage?.toString() ?? 'Requête invalide.'];
      return ValidationFailedException(details);
    }
    return const UnknownServerException();
  }
}