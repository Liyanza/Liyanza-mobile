import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'team_members.dart';

class TeamTasksScreen extends StatefulWidget {
  const TeamTasksScreen({super.key});

  @override
  State<TeamTasksScreen> createState() => _TeamTasksScreenState();
}

class _TeamTasksScreenState extends State<TeamTasksScreen> {
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

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),

                child: Column(
                  children: [
                    _buildTaskCard(
                      title: 'Valider visuels campagne',
                      priority: 'haute',
                      priorityColor: const Color(0xFFE85D75),
                      initials: 'AN',
                      name: 'Aristide Ndzi',
                      deadline: 'Échéance 30 août',
                      progress: 0.35,
                      completed: true,
                    ),

                    _buildTaskCard(
                      title: 'Envoyer brief prestataires',
                      priority: 'haute',
                      priorityColor: const Color(0xFFE85D75),
                      initials: 'MF',
                      name: 'Marie Fouda',
                      deadline: 'Échéance 2 sept',
                      progress: 0.45,
                      completed: true,
                    ),

                    _buildTaskCard(
                      title: 'Suivi installations terrain',
                      priority: 'haute',
                      priorityColor: const Color(0xFFE85D75),
                      initials: 'JM',
                      name: 'Jean-Paul Mbarga',
                      deadline: 'Échéance 2 sept',
                      progress: 0.60,
                      completed: false,
                      active: true,
                    ),

                    _buildTaskCard(
                      title: 'Analyse QR zones Est',
                      priority: 'normale',
                      priorityColor: AppColors.blue,
                      initials: 'AN',
                      name: 'Aristide Ndzi',
                      deadline: 'Échéance 4 sept',
                      progress: 0.20,
                      completed: false,
                    ),

                    _buildTaskCard(
                      title: 'Rapport conformité radio',
                      priority: 'normale',
                      priorityColor: AppColors.blue,
                      initials: 'SN',
                      name: 'Sylvie Ndzi',
                      deadline: 'Échéance 3 sept',
                      progress: 0.72,
                      completed: false,
                      active: true,
                    ),

                    _buildTaskCard(
                      title: 'Réunion bilan mi-campagne',
                      priority: 'basse',
                      priorityColor: AppColors.gray400,
                      initials: 'MF',
                      name: 'Marie Fouda',
                      deadline: 'Échéance 5 sept',
                      progress: 0.05,
                      completed: false,
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
            child: _buildTab(title: 'Tâches', selected: true, onTap: () {}),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: _buildTab(
              title: 'Équipe',

              selected: false,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamMembersScreen(),
                  ),
                );
              },
            ),
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
  // CARTE TACHE
  // ===========================================================

  Widget _buildTaskCard({
    required String title,
    required String priority,
    required Color priorityColor,
    required String initials,
    required String name,
    required String deadline,
    required double progress,
    required bool completed,
    bool active = false,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFD),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: active ? const Color(0xFFE0E4E8) : const Color(0xFFE9ECEF),
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              _buildCheckbox(completed),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  title,

                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,

                    color: completed ? AppColors.gray500 : AppColors.black,

                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),

              Text(
                priority,

                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: priorityColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                width: 20,
                height: 20,

                alignment: Alignment.center,

                decoration: const BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),

                child: Text(
                  initials,

                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              Text(
                name,

                style: const TextStyle(fontSize: 9, color: AppColors.gray500),
              ),

              const Spacer(),

              Text(
                deadline,

                style: const TextStyle(fontSize: 9, color: AppColors.gray400),
              ),
            ],
          ),

          const SizedBox(height: 7),

          _buildProgressBar(progress),
        ],
      ),
    );
  }

  Widget _buildCheckbox(bool completed) {
    return Container(
      width: 17,
      height: 17,

      decoration: BoxDecoration(
        color: completed ? AppColors.black : Colors.transparent,

        shape: BoxShape.circle,

        border: Border.all(
          color: completed ? AppColors.black : AppColors.gray400,
        ),
      ),

      child: completed
          ? const Icon(Icons.check, size: 10, color: AppColors.white)
          : null,
    );
  }

  Widget _buildProgressBar(double value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),

      child: LinearProgressIndicator(
        value: value,
        minHeight: 3,

        backgroundColor: const Color(0xFFE9EDF1),

        valueColor: AlwaysStoppedAnimation<Color>(
          value >= 0.7 ? const Color(0xFFD9C5FF) : AppColors.black,
        ),
      ),
    );
  }
}
