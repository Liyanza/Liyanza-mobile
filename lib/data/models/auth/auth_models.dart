enum UserRole { admin, marketingManager, communityManager, provider }

UserRole userRoleFromJson(String value) => switch (value) {
      'ADMIN' => UserRole.admin,
      'MARKETING_MANAGER' => UserRole.marketingManager,
      'COMMUNITY_MANAGER' => UserRole.communityManager,
      'PROVIDER' => UserRole.provider,
      _ => throw FormatException('Rôle utilisateur inconnu: $value'),
    };

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        role: userRoleFromJson(json['role'] as String),
      );
}

/// Réponse commune à /auth/login et /auth/oauth/exchange (avec `user`)
/// ET à /auth/refresh (sans `user` — voir la doc des endpoints, §1).
class AuthTokensResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel? user;

  const AuthTokensResponse({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthTokensResponse.fromJson(Map<String, dynamic> json) =>
      AuthTokensResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: json['user'] != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
      );
}