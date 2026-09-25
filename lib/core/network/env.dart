enum AppEnv { emulatorAndroid, simulatorIOS, physicalDevice, production }

class EnvConfig {
  final String baseUrl;
  const EnvConfig._(this.baseUrl);

  static EnvConfig forEnv(AppEnv env) {
    switch (env) {
      case AppEnv.emulatorAndroid:
        // 10.0.2.2 = alias spécial de l'émulateur Android vers le localhost
        // de la machine hôte. Ne fonctionne QUE sur émulateur Android.
        return const EnvConfig._('http://10.0.2.2:3000');
      case AppEnv.simulatorIOS:
        // Le simulateur iOS partage le réseau de la machine hôte :
        // localhost fonctionne directement, pas d'alias nécessaire.
        return const EnvConfig._('http://localhost:3000');
      case AppEnv.physicalDevice:
        // Téléphone physique sur le MÊME réseau Wi-Fi que la machine de dev.
        // Remplacer par l'IP LAN réelle de la machine (ipconfig/ifconfig).
        return const EnvConfig._('http://192.168.100.218:3000');
      case AppEnv.production:
        return const EnvConfig._('https://liyanza-backend.onrender.com');
    }
  }
}

// Sélection au lancement, sans toucher au code :
//   flutter run --dart-define=APP_ENV=emulatorAndroid
//   flutter run --dart-define=APP_ENV=physicalDevice
//   flutter build apk --dart-define=APP_ENV=production
const _envName = String.fromEnvironment('APP_ENV', defaultValue: 'emulatorAndroid');
final AppEnv currentEnv = AppEnv.values.firstWhere(
  (e) => e.name == _envName,
  orElse: () => AppEnv.emulatorAndroid,
);
final EnvConfig envConfig = EnvConfig.forEnv(currentEnv);