import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool twoFactor = true;
  bool faceId = false;

  bool changingPassword = false;

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    _buildPasswordCard(),

                    const SizedBox(height: 10),

                    _buildAuthenticationCard(),

                    const SizedBox(height: 10),

                    _buildSessionsCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),

          const SizedBox(width: 16),

          const Text(
            'Sécurité',

            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PASSWORD
  // ===========================================================

  Widget _buildPasswordCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'MOT DE PASSE',

            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.gray400,
            ),
          ),

          const SizedBox(height: 10),

          if (!changingPassword)
            InkWell(
              onTap: () {
                setState(() {
                  changingPassword = true;
                });
              },

              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Changer le mot de passe',

                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'Dernière modification il y a 3 mois',

                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.gray400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right, color: AppColors.gray400),
                ],
              ),
            ),

          if (changingPassword)
            Column(
              children: [
                _buildPasswordField(
                  controller: passwordController,
                  hint: 'Mot de passe actuel',
                ),

                const SizedBox(height: 10),

                _buildPasswordField(
                  controller: newPasswordController,
                  hint: 'Nouveau mot de passe',
                ),

                const SizedBox(height: 10),

                _buildPasswordField(
                  controller: confirmPasswordController,
                  hint: 'Confirmation',
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            changingPassword = false;
                          });
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gray100,
                          elevation: 0,
                        ),

                        child: const Text(
                          'Annuler',

                          style: TextStyle(color: AppColors.gray500),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            changingPassword = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mot de passe modifié'),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          elevation: 0,
                        ),

                        child: const Text(
                          'Changer',

                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,

      decoration: InputDecoration(
        hintText: hint,

        filled: true,
        fillColor: AppColors.gray100,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ===========================================================
  // AUTHENTICATION
  // ===========================================================

  Widget _buildAuthenticationCard() {
    return _buildCard(
      title: 'AUTHENTIFICATION',

      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Double authentification',
            subtitle: 'Via SMS ou application',
            value: twoFactor,

            onChanged: (value) {
              setState(() {
                twoFactor = value;
              });
            },
          ),

          const Divider(),

          _buildSwitchRow(
            title: 'Face ID / Empreinte',
            subtitle: 'Connexion biométrique',
            value: faceId,

            onChanged: (value) {
              setState(() {
                faceId = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // SESSIONS
  // ===========================================================

  Widget _buildSessionsCard() {
    return _buildCard(
      title: 'SESSIONS ACTIVES',

      child: Column(
        children: [
          _buildSession(
            icon: Icons.phone_iphone,
            title: 'iPhone 15 Pro',
            subtitle: 'Douala, CM · Actif maintenant',
            active: true,
          ),

          _buildSession(
            icon: Icons.laptop_mac,
            title: 'MacBook Pro',
            subtitle: 'Yaoundé, CM · Il y a 2h',
          ),

          _buildSession(
            icon: Icons.computer,
            title: 'Chrome / Windows',
            subtitle: 'Douala, CM · Hier, 18:34',
          ),
        ],
      ),
    );
  }

  Widget _buildSession({
    required IconData icon,
    required String title,
    required String subtitle,
    bool active = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            decoration: const BoxDecoration(
              color: AppColors.gray100,
              shape: BoxShape.circle,
            ),

            child: Icon(icon, size: 15, color: AppColors.gray500),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style: TextStyle(
                    fontSize: 9,
                    color: active ? AppColors.green : AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),

          if (!active)
            const Text(
              'Révoquer',

              style: TextStyle(fontSize: 10, color: Colors.red),
            ),
        ],
      ),
    );
  }

  // ===========================================================
  // SWITCH ROW
  // ===========================================================

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(fontSize: 12, color: AppColors.black),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,

                style: const TextStyle(fontSize: 10, color: AppColors.gray400),
              ),
            ],
          ),
        ),

        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.green,
        ),
      ],
    );
  }

  // ===========================================================
  // CARD
  // ===========================================================

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.gray400,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }
}
