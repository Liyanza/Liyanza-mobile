import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';
import '../../core/theme/kiyanza_sizes.dart';
import '../home/home.dart';

class LoginSuccessScreen extends StatelessWidget {
  const LoginSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

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
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check,
                    size: 70,
                    color: AppColors.white,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: AppColors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: AppSizes.text16,
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
