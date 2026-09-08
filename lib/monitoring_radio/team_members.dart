import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),

                child: Column(
                  children: [
                    _buildMemberCard(
                      initials: 'AN',
                      name: 'Aristide Ndzi',
                      role: 'Responsable',
                      tasks: '1/2 tâches',
                      progress: 0.55,
                      avatarColor: const Color(0xFF1F2937),
                    ),

                    _buildMemberCard(
                      initials: 'MF',
                      name: 'Marie Fouda',
                      role: 'Coordinatrice',
                      tasks: '1/2 tâches',
                      progress: 0.48,
                      avatarColor: const Color(0xFF6C45C5),
                    ),

                    _buildMemberCard(
                      initials: 'JM',
                      name: 'Jean-Paul Mbarga',
                      role: 'Terrain',
                      tasks: '0/1 tâches',
                      progress: 0.18,
                      avatarColor: const Color(0xFF3F6FC4),
                    ),

                    _buildMemberCard(
                      initials: 'SN',
                      name: 'Sylvie Ndzi',
                      role: 'Analyste',
                      tasks: '0/1 tâches',
                      progress: 0.20,
                      avatarColor: const Color(0xFFE9650B),
                    ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),

      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },

            borderRadius: BorderRadius.circular(30),

            child: Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: AppColors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            'Équipes et Tâches',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // STATISTIQUES
  // ===========================================================

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(value: '2/6', label: 'Tâches'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStatCard(value: '2', label: 'En cours'),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: _buildStatCard(value: '4', label: 'Membres'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Container(
      height: 48,

      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF7),

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFFE5E0D8)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            value,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,

            style: const TextStyle(fontSize: 9, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // TABS
  // ===========================================================

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: 'Tâches',

              selected: false,

              onTap: () {
                Navigator.pushReplacementNamed(context, '/team-tasks');
              },
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _buildTab(title: 'Équipe', selected: true, onTap: () {}),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _buildTab(title: 'Ajouter', selected: false, onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 36,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: selected ? AppColors.black : const Color(0xFFF1F3F6),

          borderRadius: BorderRadius.circular(10),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,

            color: selected ? AppColors.white : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // MEMBRE
  // ===========================================================

  Widget _buildMemberCard({
    required String initials,
    required String name,
    required String role,
    required String tasks,
    required double progress,
    required Color avatarColor,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFD),

        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,

                alignment: Alignment.center,

                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),

                child: Text(
                  initials,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      name,

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      role,

                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: const Color(0xFFF4EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: Text(
                  tasks,

                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A48C7),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,

              backgroundColor: const Color(0xFFEDE8F7),

              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF7A48C7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
