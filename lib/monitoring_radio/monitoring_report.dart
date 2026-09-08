import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';

class MonitoringReportScreen extends StatelessWidget {
  const MonitoringReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProgress(),

                  const SizedBox(height: 18),

                  _buildTabs(),

                  const SizedBox(height: 18),

                  _confirmationCard(),

                  const SizedBox(height: 8),

                  _exportButton(),
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
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

  Widget _buildProgress() {
    return Row(
      children: [
        const Text(
          '2/5',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: 0.40,
            color: AppColors.green,
            backgroundColor: const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '40%',
          style: TextStyle(fontSize: 10, color: AppColors.green),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(child: _tab('Planning')),
        const SizedBox(width: 6),
        Expanded(child: _tab('Analyse')),
        const SizedBox(width: 6),
        Expanded(child: _tab('Rapport', true)),
      ],
    );
  }

  Widget _tab(String title, [bool selected = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.green : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : AppColors.gray500,
        ),
      ),
    );
  }

  Widget _confirmationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conformité satisfaisante',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Les éléments suivis sont conformes à la diffusion prévue.',
            style: TextStyle(fontSize: 10, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _exportButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () {
          // Export futur
        },
        icon: const Icon(Icons.download, size: 16),
        label: const Text('Exporter le rapport'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
