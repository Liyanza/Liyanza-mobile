// lib/core/services/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://liyanza-backend.onrender.com';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';

  // Campagnes
  static const String campagnes = '$baseUrl/campagnes';

  // Assistant IA
  static const String iaConversations = '$baseUrl/assistant-ia/conversations';
}