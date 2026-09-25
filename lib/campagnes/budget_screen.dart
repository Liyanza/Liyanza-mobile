import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import '../core/network/app_exceptions.dart';
import '../core/providers/campagne_providers.dart';
import '../data/models/campagnes/campagne_models.dart';
import 'campaign_step_dots.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  final CampaignType type;
  final String objective;

  const BudgetScreen({super.key, required this.type, required this.objective});
  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController(
    text: '100 000',
  );

  int _selectedPresetIndex = 1; // '100K' sélectionné par défaut
  String _duration = '7 jours';
 bool _isSaving = false;

  final List<_BudgetPreset> _presets = [
    _BudgetPreset(label: '50K', amount: '50 000'),
    _BudgetPreset(label: '100K', amount: '100 000'),
    _BudgetPreset(label: '250K', amount: '250 000'),
    _BudgetPreset(label: '500K', amount: '500 000'),
  ];

// APRÈS
@override
void dispose() {
  _nameController.dispose();
  _budgetController.dispose();
  super.dispose();
}

  // ===========================================================
  // ESTIMATION (proportionnelle au budget saisi, base 100K)
  // ===========================================================

    int get _durationDays {
    final match = RegExp(r'\d+').firstMatch(_duration);
    return match != null ? int.parse(match.group(0)!) : 7;
  }
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
            // APRÈS
const CampaignStepDots(currentStep: 3, totalSteps: 5),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

                // APRÈS
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

    _buildFieldLabel('Nom de la campagne'),
    const SizedBox(height: 8),
    _buildNameInput(),

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

  Widget _buildNameInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
    ),

    child: TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        hintText: 'ex : Promo Orange Money',
        border: InputBorder.none,
        isDense: true,
      ),
    ),
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
    final presets = [..._presets, _BudgetPreset(label: 'Autre', amount: '')];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final double itemWidth = (constraints.maxWidth - spacing * 2) / 3;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(presets.length, (index) {
            final preset = presets[index];
            final bool isOther = index == presets.length - 1;

            return SizedBox(
              width: itemWidth,
              child: _buildPresetChip(
                label: preset.label,
                selected: isOther
                    ? _selectedPresetIndex == -1
                    : _selectedPresetIndex == index,
                onTap: isOther
                    ? () => setState(() => _selectedPresetIndex = -1)
                    : () => _selectPreset(index),
              ),
            );
          }),
        );
      },
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
        height: 40,
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
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.gray400),
          ),
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // BOUTON CONTINUER
  // ===========================================================

  // APRÈS
Widget _buildContinueButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

    child: SizedBox(
      width: double.infinity,
      height: 54,

      child: ElevatedButton(
        onPressed: _isSaving ? null : _handleCreate,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),

          elevation: 0,
        ),

        child: _isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.white),
              )
            : const Text(
                'Créer la campagne',

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

Future<void> _handleCreate() async {
  final name = _nameController.text.trim();
  if (name.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Le nom de la campagne est obligatoire.')),
    );
    return;
  }

  final startDate = DateTime.now();
  final endDate = startDate.add(Duration(days: _durationDays));

  setState(() => _isSaving = true);
  try {
    await ref.read(campagneRepositoryProvider).create(CreateCampagneRequest(
          name: name,
          startDate: startDate,
          endDate: endDate,
          plannedBudget: _budgetValue.toDouble(),
          objective: widget.objective,
          type: widget.type,
        ));
    // Rafraîchit la liste pour qu'elle affiche la nouvelle campagne dès le
    // retour dessus (étape 7 de ce guide — campagnesNotifierProvider).
    unawaited(ref.read(campagnesNotifierProvider.notifier).refresh());
    if (mounted) {
      // Dépile les 3 écrans du flux (Type → Objectif → Budget) d'un coup,
      // pour revenir exactement là où "Nouvelle campagne" a été ouvert. Pas
      // de route nommée dans ce flux, donc pas de raccourci plus propre que
      // ces 3 pops explicites — le nombre est fixe car ce guide n'ouvre
      // jamais ce flux autrement que Type → Objectif → Budget.
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop();
    }
  } on AppException catch (e) {
    final message = e is ValidationFailedException && e.details.isNotEmpty
        ? e.details.join('\n')
        : e.message;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  } finally {
    if (mounted) setState(() => _isSaving = false);
  }
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
