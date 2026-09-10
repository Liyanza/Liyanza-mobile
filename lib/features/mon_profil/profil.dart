import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';

import 'company_screen.dart';
import 'personal_Info_screen.dart';
import 'preferences_screen.dart';
import 'security_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),

                child: Column(
                  children: [
                    _buildProfile(),

                    const SizedBox(height: 20),

                    _buildSection(
                      title: 'MON ENTREPRISE',
                      children: [
                        _buildMenuItem(
                          context: context,
                          icon: Icons.business_outlined,
                          title: 'Boutique Orange',
                          subtitle: 'Télécommunications',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CompanyScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildSection(
                      title: 'COMPTE',
                      children: [
                        _buildMenuItem(
                          context: context,
                          icon: Icons.person_outline,
                          title: 'Informations personnelles',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PersonalInfoScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.lock_outline,
                          title: 'Sécurité',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SecurityScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.light_mode_outlined,
                          title: 'Préférences',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PreferencesScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.credit_card_outlined,
                          title: 'Méthodes de paiement',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildSection(
                      title: 'SUPPORT',
                      children: [
                        _buildMenuItem(
                          context: context,
                          icon: Icons.help_outline,
                          title: 'Centre d’aide',
                          onTap: () {},
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.mail_outline,
                          title: 'Nous contacter',
                          onTap: () {},
                        ),

                        _buildMenuItem(
                          context: context,
                          icon: Icons.info_outline,
                          title: 'À propos de KIYANZA',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildLogoutButton(),
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

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: AppColors.black,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Mon profil',

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          Container(
            width: 32,
            height: 32,

            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.light_mode_outlined,
              size: 17,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PROFIL
  // ===========================================================

  Widget _buildProfile() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Center(
                child: Text(
                  'AN',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 0,
              bottom: 0,

              child: Container(
                width: 22,
                height: 22,

                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),

                child: const Icon(
                  Icons.edit,
                  size: 12,
                  color: AppColors.gray500,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          'Aristide Nna',

          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Responsable Marketing',

          style: TextStyle(fontSize: 11, color: AppColors.gray500),
        ),

        const SizedBox(height: 3),

        const Text(
          'aristide@gmail.com',

          style: TextStyle(fontSize: 11, color: AppColors.gray400),
        ),
      ],
    );
  }

  // ===========================================================
  // SECTION
  // ===========================================================

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),

            child: Text(
              title,

              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.gray400,
                letterSpacing: 0.7,
              ),
            ),
          ),

          ...children,
        ],
      ),
    );
  }

  // ===========================================================
  // MENU ITEM
  // ===========================================================

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gray500),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 18, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // LOGOUT
  // ===========================================================

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 52,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        border: Border.all(color: const Color(0xFFFECACA)),
      ),

      child: const Center(
        child: Text(
          'Se déconnecter',

          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFFDC2626),
          ),
        ),
      ),
    );
  }
}
