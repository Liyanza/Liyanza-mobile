import 'package:flutter/material.dart';

import '../core/theme/kiyanza_colors.dart';
import 'monitoring_report.dart';

class MonitoringRadioScreen extends StatefulWidget {
  const MonitoringRadioScreen({super.key});

  @override
  State<MonitoringRadioScreen> createState() => _MonitoringRadioScreenState();
}

class _MonitoringRadioScreenState extends State<MonitoringRadioScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            _buildProgress(),

            const SizedBox(height: 12),

            _buildTabs(),

            const SizedBox(height: 16),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _dot(true),
          _line(),
          _dot(true),
          _line(),
          _dot(true),
          _line(),
          _dot(false),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: active ? AppColors.green : AppColors.gray400,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line() {
    return Expanded(child: Container(height: 1, color: AppColors.green));
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _tab('Planning', 0)),
          const SizedBox(width: 8),
          Expanded(child: _tab('Analyse', 1)),
          const SizedBox(width: 8),
          Expanded(child: _tab('Rapport', 2)),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final bool selected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (selectedTab == 0) {
      return _buildPlanning();
    }

    if (selectedTab == 1) {
      return _buildAnalysis();
    }

    return _buildReport();
  }

  // ============================================
  // PLANNING
  // ============================================

  Widget _buildPlanning() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Planning de diffusion',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 16),

        _planningCard(
          'Radio Balafon',
          '10:00 - 12:00',
          'Spot publicitaire',
          true,
        ),

        _planningCard(
          'Radio Cameroun',
          '14:00 - 16:00',
          'Spot publicitaire',
          false,
        ),

        _planningCard(
          'Radio Bonabéri',
          '18:00 - 20:00',
          'Spot publicitaire',
          false,
        ),
      ],
    );
  }

  Widget _planningCard(String radio, String hour, String type, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.radio,
            color: active ? AppColors.green : AppColors.gray400,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  radio,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.gray400,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hour,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                active ? 'En cours' : 'À venir',
                style: TextStyle(
                  fontSize: 9,
                  color: active ? AppColors.green : AppColors.gray400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // ANALYSE
  // ============================================

  Widget _buildAnalysis() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _chartCard(),

          const SizedBox(height: 14),

          _analysisItem('Diffusions prévues', '5'),

          _analysisItem('Diffusions confirmées', '2'),

          _analysisItem('Taux de conformité', '40%'),
        ],
      ),
    );
  }

  Widget _chartCard() {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Taux de diffusion',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_bar(45), _bar(70), _bar(95), _bar(60), _bar(80)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double height) {
    return Container(
      width: 18,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF4F78B8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _analysisItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFFAFAFA),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.gray500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ============================================
  // RAPPORT
  // ============================================

  Widget _buildReport() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MonitoringReportScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            minimumSize: const Size(double.infinity, 50),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'Voir le rapport',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
