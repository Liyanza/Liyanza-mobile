import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'support.dart';
import 'support_prestataire.dart';

class SupportVerificationScreen extends StatelessWidget {
  const SupportVerificationScreen({super.key});

  static const Color _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const SizedBox(height: 12),

            _buildStatistics(),

            const SizedBox(height: 10),

            _buildTabs(context),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: _buildVerificationList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 10),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _borderColor)),
      ),

      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),

            onTap: () {
              Navigator.pop(context);
            },

            child: const Padding(
              padding: EdgeInsets.all(8),

              child: Icon(Icons.arrow_back_ios_new, size: 17),
            ),
          ),

          const SizedBox(width: 6),

          const Expanded(
            child: Text(
              'Supports publicitaires',

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTIQUES
  // ============================================================

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: Row(
        children: [
          Expanded(
            child: _buildStat(value: '3/6', label: 'Validés'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStat(value: '1', label: 'En cours'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStat(value: '2', label: 'En attente'),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required String value, required String label}) {
    return Container(
      height: 48,

      decoration: BoxDecoration(
        color: const Color(0xFFFAF7F1),

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFFE5DED3)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            value,

            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),

          Text(
            label,

            style: const TextStyle(fontSize: 8, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: Container(
        height: 38,

        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            Expanded(
              child: _buildTab(
                text: 'Missions',
                selected: false,

                onTap: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(builder: (_) => const SupportsScreen()),
                  );
                },
              ),
            ),

            Expanded(
              child: _buildTab(
                text: 'Prestataires',
                selected: false,

                onTap: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(
                      builder: (_) => const SupportProvidersScreen(),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: _buildTab(text: 'Vérif.', selected: true, onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111111) : Colors.transparent,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Text(
          text,

          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,

            color: selected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VERIFICATION LIST
  // ============================================================

  Widget _buildVerificationList() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: _borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'LISTE DE VÉRIFICATION',

            style: TextStyle(
              fontSize: 8,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9CA3AF),
            ),
          ),

          const SizedBox(height: 14),

          _buildVerificationItem(
            title: 'Photos de pose téléchargées',
            value: '2/6',
          ),

          const SizedBox(height: 14),

          _buildVerificationItem(
            title: 'Géolocalisation confirmée',
            value: '3/6',
          ),

          const SizedBox(height: 14),

          _buildVerificationItem(title: 'Missions validées', value: '3/6'),
        ],
      ),
    );
  }

  Widget _buildVerificationItem({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            border: Border.all(color: const Color(0xFFF59E0B), width: 1),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,

            style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
          ),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFFB45309),
          ),
        ),
      ],
    );
  }
}
