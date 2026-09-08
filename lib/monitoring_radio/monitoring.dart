import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';
import 'monitoring_radio.dart';

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),

            _tabs(),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _monitoringItem(
                    context,
                    'Radio Balafon',
                    'Radio Cameroun • 25 mai',
                    '65%',
                    AppColors.green,
                    Icons.radio,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MonitoringRadioScreen(),
                        ),
                      );
                    },
                  ),

                  _monitoringItem(
                    context,
                    'Canal 2',
                    'Campagne TV • 20 mai',
                    '90%',
                    AppColors.green,
                    Icons.tv_outlined,
                    () {},
                  ),

                  _monitoringItem(
                    context,
                    'Équipe TV',
                    'Activités terrain',
                    'En retard',
                    Colors.red,
                    Icons.groups_outlined,
                    () {},
                  ),

                  _monitoringItem(
                    context,
                    'Radio Balafon',
                    'Campagne radio',
                    'À suivre',
                    Colors.orange,
                    Icons.radio_outlined,
                    () {},
                  ),

                  _monitoringItem(
                    context,
                    'Radio Cameroun',
                    'Campagne radio',
                    'En cours',
                    AppColors.green,
                    Icons.radio,
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
                'Monitoring Radio',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _tabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _tab('Planning', true)),
          const SizedBox(width: 8),
          Expanded(child: _tab('Analyse', false)),
          const SizedBox(width: 8),
          Expanded(child: _tab('Rapport', false)),
        ],
      ),
    );
  }

  Widget _tab(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.green : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: selected ? Colors.white : AppColors.gray500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _monitoringItem(
    BuildContext context,
    String title,
    String subtitle,
    String status,
    Color statusColor,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: statusColor, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
