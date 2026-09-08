import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import 'campaign_step_dots.dart';
import 'channels_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController(
    text: '100 000',
  );

  int _selectedPresetIndex = 1; // '100K' sélectionné par défaut
  String _duration = '7 jours';

  final List<_BudgetPreset> _presets = [
    _BudgetPreset(label: '50K', amount: '50 000'),
    _BudgetPreset(label: '100K', amount: '100 000'),
    _BudgetPreset(label: '250K', amount: '250 000'),
    _BudgetPreset(label: '500K', amount: '500 000'),
  ];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  // ===========================================================
  // ESTIMATION (proportionnelle au budget saisi, base 100K)
  // ===========================================================

  int get _budgetValue {
    final raw = _budgetController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(raw) ?? 100000;
  }

  String get _estimatedReach {
    final factor = _budgetValue / 100000;
    final low = (25000 * factor).round();
    final high = (40000 * factor).round();
    return '${_formatNumber(low)} – ${_formatNumber(high)} personnes';
  }

  String get _estimatedProspects {
    final factor = _budgetValue / 100000;
    final low = (800 * factor).round();
    final high = (1200 * factor).round();
    return '${_formatNumber(low)} – ${_formatNumber(high)}';
  }

  String _formatNumber(int value) {
    final str = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      if (i != 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }

    return buffer.toString();
  }

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _selectPreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _budgetController.text = _presets[index].amount;
    });
  }

  Future<void> _selectDuration() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        const options = ['3 jours', '7 jours', '14 jours', '30 jours'];

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: options
                .map(
                  (option) => ListTile(
                    title: Text(option, style: const TextStyle(fontSize: 14)),
                    onTap: () => Navigator.pop(context, option),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _duration = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================

            _buildHeader(context),

            // =================================================
            // STEP DOTS
            // =================================================
            const CampaignStepDots(currentStep: 3),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Quel est votre budget ?',

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildFieldLabel('Budget total'),
                    const SizedBox(height: 8),
                    _buildBudgetInput(),

                    const SizedBox(height: 12),

                    _buildPresetsRow(),

                    const SizedBox(height: 20),

                    _buildFieldLabel('Durée de la campagne'),
                    const SizedBox(height: 8),
                    _buildDurationField(),

                    const SizedBox(height: 20),

                    _buildEstimationCard(),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOUTON CONTINUER
            // =================================================
            _buildContinueButton(context),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

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
                'Budget',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ),
          ),

          const SizedBox(width: 22),
        ],
      ),
    );
  }

  // ===========================================================
  // LABEL DE CHAMP
  // ===========================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label,

      style: const TextStyle(fontSize: 12, color: AppColors.gray400),
    );
  }

  // ===========================================================
  // CHAMP BUDGET (montant en grand)
  // ===========================================================

  Widget _buildBudgetInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5489DE), width: 1.2),
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,

              onChanged: (value) {
                setState(() => _selectedPresetIndex = -1);
              },

              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.black,
              ),
            ),
          ),

          const Text(
            'FCFA',

            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PRESETS RAPIDES
  // ===========================================================

  Widget _buildPresetsRow() {
    return Row(
      children: [
        ...List.generate(_presets.length, (index) {
          final bool selected = _selectedPresetIndex == index;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == _presets.length - 1 ? 0 : 8,
              ),

              child: _buildPresetChip(
                label: _presets[index].label,
                selected: selected,
                onTap: () => _selectPreset(index),
              ),
            ),
          );
        }),

        const SizedBox(width: 8),

        Expanded(
          child: _buildPresetChip(
            label: 'Autre',
            selected: _selectedPresetIndex == -1,
            onTap: () {
              setState(() => _selectedPresetIndex = -1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),

        decoration: BoxDecoration(
          color: selected ? AppColors.blue : AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Text(
          label,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.gray500,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // DURÉE DE LA CAMPAGNE
  // ===========================================================

  Widget _buildDurationField() {
    return GestureDetector(
      onTap: _selectDuration,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              _duration,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // ESTIMATION RAPIDE
  // ===========================================================

  Widget _buildEstimationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7EA6E7), width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.black),

              SizedBox(width: 8),

              Text(
                'Estimation rapide',

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildEstimationRow('Portée estimée', _estimatedReach),

          const SizedBox(height: 8),

          _buildEstimationRow('Prospects estimés', _estimatedProspects),
        ],
      ),
    );
  }

  Widget _buildEstimationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,

          style: const TextStyle(fontSize: 12, color: AppColors.gray400),
        ),

        Text(
          value,

          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // BOUTON CONTINUER
  // ===========================================================

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

      child: SizedBox(
        width: double.infinity,
        height: 54,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChannelsScreen()),
            );
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),

            elevation: 0,
          ),

          child: const Text(
            'Continuer',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// MODEL
// =============================================================

class _BudgetPreset {
  final String label;
  final String amount;

  _BudgetPreset({required this.label, required this.amount});
}
