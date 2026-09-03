import 'package:flutter/material.dart';

import '../../onboarding/presentation/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Au début, l'application est en chargement
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Temps de chargement : 3 secondes
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              Image.asset('assets/images/Logo_kiyanza.png', width: 180),

              const SizedBox(height: 40),

              // Titre
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

              const Spacer(),

              // Zone qui change après 3 secondes
              AnimatedSwitcher(
                duration: const Duration(seconds: 5),

                child: _isLoading
                    ? const Column(
                        key: ValueKey('loading'),
                        children: [
                          CircularProgressIndicator(),

                          SizedBox(height: 10),

                          Text(
                            'Chargement...',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      )
                    // Après le chargement
                    : SizedBox(
                        key: const ValueKey('discover'),
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
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Découvrir'),
                        ),
                      ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
