/// Adresse de l'API Kiyanza (backend NestJS hébergé sur AWS).
///
/// Production par défaut. Pour viser une autre API (backend local, tests),
/// sans toucher au code :
///   flutter run --dart-define=API_URL=http://10.0.2.2:3000   (émulateur Android)
///   flutter run --dart-define=API_URL=http://192.168.1.20:3000 (téléphone, IP LAN du PC)
const String productionApiUrl = 'https://api.kiyanza.com';

class EnvConfig {
  final String baseUrl;
  const EnvConfig._(this.baseUrl);
}

const _apiUrlOverride = String.fromEnvironment('API_URL');

final EnvConfig envConfig = EnvConfig._(
  _apiUrlOverride.isNotEmpty ? _apiUrlOverride : productionApiUrl,
);
