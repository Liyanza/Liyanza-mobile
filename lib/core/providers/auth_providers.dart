import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/env.dart';
import '../storage/secure_token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/auth/auth_models.dart';
import '../network/api_client.dart';

final secureTokenStorageProvider = Provider((ref) => SecureTokenStorage());

final authRemoteDatasourceProvider =
    Provider((ref) => AuthRemoteDatasource(envConfig.baseUrl));

final authRepositoryProvider = Provider((ref) => AuthRepository(
      ref.read(authRemoteDatasourceProvider),
      ref.read(secureTokenStorageProvider),
    ));

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  const AuthState({required this.status, this.user, this.errorMessage});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState(status: AuthStatus.checking)) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final hasSession = await _repository.hasStoredSession();
    state = AuthState(
      status: hasSession ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String email, String password) async {
    final user = await _repository.login(email, password);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

final apiClientProvider = Provider((ref) => ApiClient(
      baseUrl: envConfig.baseUrl,
      tokenStorage: ref.read(secureTokenStorageProvider),
      authDatasource: ref.read(authRemoteDatasourceProvider),
    ));