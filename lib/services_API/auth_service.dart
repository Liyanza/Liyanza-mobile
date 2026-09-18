// lib/core/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class AuthService {
  // Stockage temporaire en mémoire du token de session
  static String? token;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 45)); // Render gratuit peut prendre du temps

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Ajustez la clé selon la réponse de votre login.dto.ts (ex: accessToken ou token)
        token = data['accessToken'] ?? data['token'];
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}