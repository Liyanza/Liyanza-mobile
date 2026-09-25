import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';

class ApiClient {
  final Dio dio;
  final SecureTokenStorage _tokenStorage;
  final AuthRemoteDatasource _authDatasource;

  // Verrou anti-concurrence : le refresh token backend est CONSOMMÉ de façon
  // atomique côté serveur (rotation, GETDEL Redis — voir doc API §1). Si deux
  // requêtes échouent en 401 en même temps, la seconde à tenter un refresh
  // avec le même (ancien) refreshToken échouerait. On sérialise donc les
  // tentatives : la première déclenche le refresh, les suivantes attendent
  // son résultat au lieu d'en lancer un second.
  Completer<String>? _refreshCompleter;

  ApiClient({
    required String baseUrl,
    required SecureTokenStorage tokenStorage,
    required AuthRemoteDatasource authDatasource,
  })  : _tokenStorage = tokenStorage,
        _authDatasource = authDatasource,
        dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.readAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (DioException error, handler) async {
        final isAuthRoute = error.requestOptions.path.startsWith('/auth/');
        final is401 = error.response?.statusCode == 401;

        // Un 401 sur une route /auth/* (ex: mauvais mot de passe sur
        // /auth/login) signifie "identifiants invalides", PAS "token expiré".
        // Le confondre déclencherait un refresh absurde sur un endpoint qui
        // n'utilise même pas de token.
        if (is401 && !isAuthRoute) {
          try {
            final newAccessToken = await _refreshAccessToken();
            final retryRequest = error.requestOptions
              ..headers['Authorization'] = 'Bearer $newAccessToken';
            final response = await dio.fetch(retryRequest);
            return handler.resolve(response);
          } catch (_) {
            // Refresh token lui-même invalide/expiré : session réellement
            // terminée. On nettoie et on laisse l'erreur remonter — c'est à
            // la couche UI (via authNotifierProvider) de rediriger vers le login.
            await _tokenStorage.clear();
            return handler.next(error);
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<String> _refreshAccessToken() {
    if (_refreshCompleter != null) return _refreshCompleter!.future;

    final completer = Completer<String>();
    _refreshCompleter = completer;

    () async {
      try {
        final refreshToken = await _tokenStorage.readRefreshToken();
        if (refreshToken == null) {
          throw StateError('Aucun refresh token stocké.');
        }
        final tokens = await _authDatasource.refresh(refreshToken);
        // Rotation obligatoire : TOUJOURS remplacer les deux tokens, jamais
        // garder l'ancien refreshToken (il vient d'être invalidé côté serveur).
        await _tokenStorage.saveTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
        completer.complete(tokens.accessToken);
      } catch (e, st) {
        completer.completeError(e, st);
      } finally {
        _refreshCompleter = null;
      }
    }();

    return completer.future;
  }
}