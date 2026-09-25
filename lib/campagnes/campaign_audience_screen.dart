import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import '../../../core/theme/kiyanza_sizes.dart';
import '../data/models/campagnes/campagne_models.dart';
import 'budget_screen.dart';

import 'campaign_step_dots.dart';

class CampaignAudienceScreen extends StatefulWidget {
  final CampaignType type;
  final String objective;

  const CampaignAudienceScreen({
    super.key,
    required this.type,
    required this.objective,
  });

  @override
  State<CampaignAudienceScreen> createState() => _CampaignAudienceScreenState();
}

class _CampaignAudienceScreenState extends State<CampaignAudienceScreen> {
  String _age = '18 - 35 ans';
  String _gender = 'Tous';
  String _location = 'Yaoundé, Douala';

  final List<String> _interests = ['Technologie', 'Mode', 'Sport'];

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  Future<void> _selectDemographic(String label) async {
    if (label == 'Localisation') {
      await _editLocation();
      return;
    }

    final options = label == 'Âge'
        ? ['13 - 17 ans', '18 - 35 ans', '36 - 50 ans', '51 ans et +']
        : ['Tous', 'Femmes', 'Hommes'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (option) => ListTile(
                  title: Text(option),
                  trailing: option == (label == 'Âge' ? _age : _gender)
                      ? const Icon(Icons.check, color: AppColors.green)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (selected == null) return;
    setState(() {
      if (label == 'Âge') {
        _age = selected;
      } else {
        _gender = selected;
      }
    });
  }

  Future<void> _editLocation() async {
    final controller = TextEditingController(text: _location);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Localisation'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Ex. Yaoundé, Douala'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Valider'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (value != null && value.isNotEmpty) {
      setState(() => _location = value);
    }
  }

  Future<void> _addInterest() async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un intérêt'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Ex. Musique'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (value != null && value.isNotEmpty && !_interests.contains(value)) {
      setState(() => _interests.add(value));
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
            const CampaignStepDots(currentStep: 2),

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
                      'Qui souhaitez-vous atteindre ?',

                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildSectionLabel('Démographie'),

                    const SizedBox(height: 10),

                    _buildDemographicsCard(),

                    const SizedBox(height: 20),

                    _buildSectionLabel('Intérêts'),

                    const SizedBox(height: 10),

                    _buildInterestsCard(),
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
                'Votre audience',

                style: TextStyle(
                  fontSize: AppSizes.text16,
                  fontWeight: FontWeight.w600,
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
  // LABEL DE SECTION
  // ===========================================================

  Widget _buildSectionLabel(String label) {
    return Text(
      label,

      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: AppColors.gray500,
      ),
    );
  }

  // ===========================================================
  // CARTE DÉMOGRAPHIE
  // ===========================================================

  Widget _buildDemographicsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        children: [
          _buildDemographicsRow('Âge', _age, showBorder: true),
          _buildDemographicsRow('Genre', _gender, showBorder: true),
          _buildDemographicsRow('Localisation', _location, showBorder: false),
        ],
      ),
    );
  }

  Widget _buildDemographicsRow(
    String label,
    String value, {
    required bool showBorder,
  }) {
    return GestureDetector(
      onTap: () => _selectDemographic(label),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
                  bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2),
                )
              : null,
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              label,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.gray500,
              ),
            ),

            Row(
              children: [
                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray400,
                  ),
                ),

                const SizedBox(width: 6),

                const Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppColors.gray400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CARTE INTÉRÊTS
  // ===========================================================

  Widget _buildInterestsCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Ajouter des centres d’intérêt',

            style: TextStyle(fontSize: 12, color: AppColors.gray400),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: [
              ..._interests.map(_buildInterestChip),
              _buildAddInterestButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Text(
            interest,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),

          const SizedBox(width: 6),

          GestureDetector(
            onTap: () => _removeInterest(interest),

            child: const Icon(Icons.close, size: 12, color: AppColors.gray400),
          ),
        ],
      ),
    );
  }

  Widget _buildAddInterestButton() {
    return GestureDetector(
      onTap: _addInterest,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            width: 1.2,
            style: BorderStyle.solid,
          ),
        ),

        child: const Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(Icons.add, size: 11, color: AppColors.gray400),

            SizedBox(width: 4),

            Text(
              'Ajouter',

              style: TextStyle(fontSize: 12, color: AppColors.gray400),
            ),
          ],
        ),
      ),
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
              MaterialPageRoute(
                builder: (_) => BudgetScreen(
                  type: widget.type,
                  objective: widget.objective,
                ),
              ),
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
