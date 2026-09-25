import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../onboarding/presentation/onboarding.dart';
import '../../../core/providers/auth_providers.dart';
import '../../../core/navigation/main_navigation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Laisse le temps à AuthNotifier de terminer sa vérification initiale
    // (lecture du secure storage) avant de décider où naviguer.
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectWhenReady());
  }

  Future<void> _redirectWhenReady() async {
    // Attend que le statut ne soit plus "checking" (poll simple, le
    // AuthNotifier termine sa vérification en quelques millisecondes —
    // lecture locale du secure storage, pas d'appel réseau).
    while (ref.read(authNotifierProvider).status == AuthStatus.checking) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (!mounted) return;

    final status = ref.read(authNotifierProvider).status;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => status == AuthStatus.authenticated
        ? const MainNavigationScreen()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.sizeOf(context).width < 260
        ? MediaQuery.sizeOf(context).width
        : 250;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: logoSize,
                height: logoSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/images/logo_tour.png', width: logoSize),
                    Transform.translate(
                      offset: const Offset(15, 0),
                      child: const Image(
                        image: AssetImage('assets/images/Logo_kiyanza.png'),
                        width: 180,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Bienvenue sur '),
                    TextSpan(
                      text: 'Kiyanza',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1BB14A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Votre copilote marketing intelligent',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 250),
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BB14A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Découvrir',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
