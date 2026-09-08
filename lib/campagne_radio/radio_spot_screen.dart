import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'radio_schedule_screen.dart';
import 'radio_step_header.dart';

class RadioSpotScreen extends StatefulWidget {
  const RadioSpotScreen({super.key});

  @override
  State<RadioSpotScreen> createState() => _RadioSpotScreenState();
}

class _RadioSpotScreenState extends State<RadioSpotScreen> {
  final TextEditingController _spotNameController = TextEditingController(
    text: 'Promo_Orange_Mai24',
  );

  String? _importedFileName;
  final String _duration = '30 sec';

  @override
  void dispose() {
    _spotNameController.dispose();
    super.dispose();
  }

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _importSpot() {
    // TODO: brancher un vrai file picker (ex: file_picker package)
    setState(() {
      _importedFileName = 'Promo_Orange_Mai24.mp3';
    });
  }

  void _recordMessage() {
    // TODO: ouvrir l'enregistreur audio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER + PROGRESSION
            // =================================================

            const RadioStepHeader(
              title: 'Nouvelle campagne radio',
              step: 3,
              totalSteps: 5,
            ),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Spot radio',

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray500,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildImportZone(),

                    const SizedBox(height: 12),

                    _buildDivider(),

                    const SizedBox(height: 16),

                    _buildRecordButton(),

                    const SizedBox(height: 20),

                    _buildFieldLabel('Nom du spot'),
                    const SizedBox(height: 6),
                    _buildSpotNameField(),

                    const SizedBox(height: 16),

                    _buildDurationRow(),
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
  // ZONE D'IMPORT
  // ===========================================================

  Widget _buildImportZone() {
    return GestureDetector(
      onTap: _importSpot,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),

        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            width: 1.2,
            style: BorderStyle.solid,
          ),
        ),

        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Icon(
                Icons.upload_outlined,
                size: 22,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              _importedFileName == null
                  ? 'Importer un spot'
                  : 'Fichier importé · $_duration',

              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.gray500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _importedFileName ?? 'MP3, WAV (max 30Mo)',

              style: const TextStyle(fontSize: 12, color: AppColors.gray400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),

          child: Text(
            'Ou enregistrer un message',

            style: TextStyle(fontSize: 12, color: AppColors.gray400),
          ),
        ),

        Expanded(child: Divider(color: Color(0xFFE5E7EB), thickness: 1)),
      ],
    );
  }

  Widget _buildRecordButton() {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: _recordMessage,

        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFF5489DE), width: 1.2),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        icon: const Icon(Icons.mic_none, size: 16, color: AppColors.gray500),

        label: const Text(
          'Enregistrer',

          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.gray500,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // NOM DU SPOT
  // ===========================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label.toUpperCase(),

      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.gray400,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildSpotNameField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: TextField(
        controller: _spotNameController,

        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),

        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildDurationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const Text(
            'Durée du spot',

            style: TextStyle(fontSize: 13, color: AppColors.gray500),
          ),

          Text(
            _duration,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // BOUTON CONTINUER
  // ===========================================================

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: SizedBox(
        width: double.infinity,
        height: 53,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RadioScheduleScreen()),
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
