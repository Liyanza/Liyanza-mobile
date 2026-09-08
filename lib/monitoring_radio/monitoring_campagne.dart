import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';
import 'monitoring_radio.dart';
import 'support.dart';
import 'team_tasks.dart';

class MonitoringCampaignScreen extends StatelessWidget {
  const MonitoringCampaignScreen({super.key});

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
                    _buildCampaignBanner(),

                    const SizedBox(height: 12),

                    _buildStats(),

                    const SizedBox(height: 16),

                    _buildSectionTitle('Monitoring Radio'),

                    const SizedBox(height: 8),

                    _buildCard(
                      context: context,
                      title: 'Radio Balafon',
                      subtitle: 'Campagne radio • 25 mai 2024',
                      progress: 0.65,
                      status: '65%',
                      statusColor: AppColors.green,
                      icon: Icons.radio,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MonitoringRadioScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    _buildSectionTitle('Autres éléments'),

                    const SizedBox(height: 8),

                    _buildCard(
                      context: context,

                      title: 'Support publicitaire',

                      subtitle: 'Suivi des supports de communication',

                      progress: 0.55,

                      status: 'À suivre',

                      statusColor: Colors.orange,

                      icon: Icons.campaign_outlined,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SupportsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    _buildCard(
                      context: context,
                      title: 'Équipes et tâches',
                      subtitle: 'Suivez les activités terrain',
                      progress: 0.70,
                      status: '4/6',
                      statusColor: AppColors.green,
                      icon: Icons.groups_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeamTasksScreen(),
                          ),
                        );
                      },
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
            iconSize: 18,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Monitoring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCampaignBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1BB14A), Color(0xFF3F72C5)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.radio, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Campagne active',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text('Radio', style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _statCard('5', 'Jours')),
        const SizedBox(width: 8),
        Expanded(child: _statCard('68%', 'Budget')),
        const SizedBox(width: 8),
        Expanded(child: _statCard('8/14', 'Tâches')),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double progress,
    required String status,
    required Color statusColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: AppColors.gray400),
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              color: AppColors.green,
              backgroundColor: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}
