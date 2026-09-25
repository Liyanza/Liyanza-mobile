import '../datasources/auth_remote_datasource.dart';
import '../models/auth/auth_models.dart';
import '../../core/storage/secure_token_storage.dart';

class AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureTokenStorage _storage;

  AuthRepository(this._remote, this._storage);

  Future<UserModel> login(String email, String password) async {
    final response = await _remote.login(email, password);
    await _storage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    // `user` est toujours présent sur la réponse de /auth/login (voir doc API §1).
    return response.user!;
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) {
    return _remote.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }

  Future<void> logout() async {
    final accessToken = await _storage.readAccessToken();
    final refreshToken = await _storage.readRefreshToken();
    if (accessToken != null) {
      // Toujours transmettre le refreshToken courant : ferme UNIQUEMENT la
      // session mobile, pas les autres sessions actives de l'utilisateur
      // (ex: session web ouverte ailleurs). L'omettre déconnecterait tout.
      await _remote.logout(accessToken: accessToken, refreshToken: refreshToken);
    }
    await _storage.clear();
  }

  Future<bool> hasStoredSession() async {
    return (await _storage.readAccessToken()) != null;
  }

  Future<void> forgotPassword(String email) => _remote.forgotPassword(email);
}