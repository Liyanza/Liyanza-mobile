// lib/core/services/campagne_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

class CampagneService {
  Future<List<dynamic>> getCampagnes() async {
    final url = Uri.parse(ApiConstants.campagnes);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Erreur ${response.statusCode} lors du chargement');
    }
  }

  Future<bool> createCampagne(Map<String, dynamic> campagneData) async {
    final url = Uri.parse(ApiConstants.campagnes);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.token}',
      },
      body: jsonEncode(campagneData),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }
}