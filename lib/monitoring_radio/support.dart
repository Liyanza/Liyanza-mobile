import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'support_prestataire.dart';
import 'support_verification.dart';

class SupportsScreen extends StatelessWidget {
  const SupportsScreen({super.key});

  static const Color _borderColor = Color(0xFFE5E7EB);
  static const Color _backgroundColor = Color(0xFFF9FAFB);
  static const Color _textSecondary = Color(0xFF9CA3AF);

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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                children: [
                  _buildMissionCard(
                    name: 'Pose affiche Akwa',
                    location: 'MediaCam SARL · M01',
                    status: 'validé',
                    statusColor: AppColors.green,
                    photo: true,
                    geolocation: true,
                  ),

                  _buildMissionCard(
                    name: 'Banderole Mboppi',
                    location: 'AffiCam Pro · M02',
                    status: 'validé',
                    statusColor: AppColors.green,
                    photo: true,
                    geolocation: true,
                  ),

                  _buildMissionCard(
                    name: 'Spot LED Carrefour',
                    location: 'LedGroup CM · M03',
                    status: 'validé',
                    statusColor: AppColors.green,
                    photo: true,
                    geolocation: true,
                  ),

                  _buildMissionCard(
                    name: 'Flyers Zone Sud',
                    location: 'PrintCam · M04',
                    status: 'en cours',
                    statusColor: Colors.orange,
                    photo: false,
                    geolocation: false,
                  ),

                  _buildMissionCard(
                    name: 'Pose vitrine Bonanjo',
                    location: 'MediaCam SARL · M05',
                    status: 'en attente',
                    statusColor: _textSecondary,
                    photo: false,
                    geolocation: false,
                  ),

                  _buildMissionCard(
                    name: 'Banderole Bonabéri',
                    location: 'AffiCam Pro · M06',
                    status: 'en attente',
                    statusColor: _textSecondary,
                    photo: false,
                    geolocation: false,
                  ),

                  const SizedBox(height: 20),
                ],
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
        border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
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

              child: Icon(
                Icons.arrow_back_ios_new,
                size: 17,
                color: Color(0xFF374151),
              ),
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
            child: _buildStatCard(value: '3/6', label: 'Validés'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStatCard(value: '1', label: 'En cours'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStatCard(value: '2', label: 'En attente'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
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

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 2),

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
              child: _buildTab(text: 'Missions', selected: true, onTap: () {}),
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
              child: _buildTab(
                text: 'Vérif.',
                selected: false,

                onTap: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(
                      builder: (_) => const SupportVerificationScreen(),
                    ),
                  );
                },
              ),
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
        height: 38,

        decoration: BoxDecoration(
          color: selected ? const Color(0xFF111827) : Colors.transparent,

          borderRadius: BorderRadius.circular(12),
        ),

        alignment: Alignment.center,

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
  // MISSION CARD
  // ============================================================

  Widget _buildMissionCard({
    required String name,
    required String location,
    required String status,
    required Color statusColor,
    required bool photo,
    required bool geolocation,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: _backgroundColor,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: _borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF374151),
                  ),
                ),
              ),

              Text(
                status,

                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            location,

            style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.photo_outlined,
                size: 11,
                color: photo ? AppColors.green : const Color(0xFFD1D5DB),
              ),

              const SizedBox(width: 3),

              Text(
                'Photo',

                style: TextStyle(
                  fontSize: 8,
                  color: photo
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFD1D5DB),
                ),
              ),

              const SizedBox(width: 12),

              Icon(
                Icons.location_on_outlined,
                size: 11,
                color: geolocation ? AppColors.green : const Color(0xFFD1D5DB),
              ),

              const SizedBox(width: 3),

              Text(
                'Géoloc',

                style: TextStyle(
                  fontSize: 8,
                  color: geolocation
                      ? const Color(0xFF6B7280)
                      : const Color(0xFFD1D5DB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
