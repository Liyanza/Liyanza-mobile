import 'package:flutter/material.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône de succès
                Container(
                  width: 120,
                  height: 120,

                  decoration: const BoxDecoration(
                    color: const Color(0xFF1BB14A),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check,
                    size: 70,
                    color: Color(0xFFFFFFFF),
                  ),
                ),

                const SizedBox(height: 35),

                // Titre
                const Text(
                  'Connexion réussie !',
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                // Description
                const Text(
                  'Bienvenue Leane, Vous pouvez continuer vos activites en toute securite  sur Kiyanza',
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 50),

                // Bouton Continuer
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: () {
                      // Plus tard → Dashboard
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1BB14A),
                      foregroundColor: const Color(0xFFFFFFFF),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
