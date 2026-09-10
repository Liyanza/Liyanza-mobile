import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String theme = 'Clair';
  String language = 'FR';

  bool campaignNotifications = true;
  bool weeklyReports = true;
  bool aiSuggestions = false;
  bool paymentAlerts = true;

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
                    _buildAppearance(),

                    const SizedBox(height: 12),

                    _buildLanguage(),

                    const SizedBox(height: 12),

                    _buildNotifications(),
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
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),

          const SizedBox(width: 16),

          const Text(
            'Préférences',

            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // APPARENCE
  // ===========================================================

  Widget _buildAppearance() {
    return _buildCard(
      title: 'APPARENCE',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Thème',

            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildThemeButton('Clair'),

              const SizedBox(width: 8),

              _buildThemeButton('Sombre'),

              const SizedBox(width: 8),

              _buildThemeButton('Auto'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton(String value) {
    final selected = theme == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            theme = value;
          });
        },

        child: Container(
          height: 38,

          decoration: BoxDecoration(
            color: selected ? AppColors.green : const Color(0xFFF3F4F6),

            borderRadius: BorderRadius.circular(20),
          ),

          child: Center(
            child: Text(
              value,

              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.gray500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // LANGUAGE
  // ===========================================================

  Widget _buildLanguage() {
    return _buildCard(
      title: 'LANGUE & DEVISE',

      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Langue de l’interface',

                  style: TextStyle(fontSize: 12, color: AppColors.gray500),
                ),
              ),

              _buildLanguageButton('FR'),

              const SizedBox(width: 6),

              _buildLanguageButton('EN'),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Devise',

                      style: TextStyle(fontSize: 12, color: AppColors.gray500),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Utilisée pour les budgets',

                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: const Row(
                  children: [
                    Text('XAF (FCFA)', style: TextStyle(fontSize: 10)),

                    SizedBox(width: 4),

                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String value) {
    final selected = language == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          language = value;
        });
      },

      child: Container(
        width: 36,
        height: 30,

        decoration: BoxDecoration(
          color: selected ? AppColors.blue : AppColors.gray100,

          borderRadius: BorderRadius.circular(8),
        ),

        child: Center(
          child: Text(
            value,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.white : AppColors.gray500,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // NOTIFICATIONS
  // ===========================================================

  Widget _buildNotifications() {
    return _buildCard(
      title: 'NOTIFICATIONS',

      child: Column(
        children: [
          _buildSwitch(
            title: 'Mises à jour campagnes',
            value: campaignNotifications,
            onChanged: (value) {
              setState(() {
                campaignNotifications = value;
              });
            },
          ),

          _buildSwitch(
            title: 'Rapports hebdo',
            value: weeklyReports,
            onChanged: (value) {
              setState(() {
                weeklyReports = value;
              });
            },
          ),

          _buildSwitch(
            title: 'Suggestions IA',
            value: aiSuggestions,
            onChanged: (value) {
              setState(() {
                aiSuggestions = value;
              });
            },
          ),

          _buildSwitch(
            title: 'Alertes paiement',
            value: paymentAlerts,
            onChanged: (value) {
              setState(() {
                paymentAlerts = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 12, color: AppColors.gray500),
            ),
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.blue,
          ),
        ],
      ),
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
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }
}
