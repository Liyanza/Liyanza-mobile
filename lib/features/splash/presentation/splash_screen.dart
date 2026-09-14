import 'package:flutter/material.dart';

import '../../onboarding/presentation/onboarding.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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

              // ================================================
              // LOGO
              // ================================================

              SizedBox(
                width: 300,
                height: 300,

                child: Stack(
                  alignment: Alignment.center,

                  children: [
                    Image.asset(
                      'assets/images/logo_tour.png',
                      width: 300,
                    ),

                    Transform.translate(
                      offset: const Offset(15, 0),

                      child: Image.asset(
                        'assets/images/Logo_kiyanza.png',
                        width: 180,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ================================================
              // TITRE
              // ================================================

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),

                  children: [
                    TextSpan(
                      text: 'Bienvenue sur ',
                    ),

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

              // ================================================
              // SOUS-TITRE
              // ================================================

              const Text(
                'Votre copilote marketing intelligent',

                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              // ================================================
              // BOUTON DÉCOUVRIR
              // ================================================

              SizedBox(
                width: 220,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const OnboardingScreen(),
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

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
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