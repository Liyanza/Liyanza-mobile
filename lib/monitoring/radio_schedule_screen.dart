import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'radio_recap_screen.dart';
import 'radio_step_header.dart';

class RadioScheduleScreen extends StatefulWidget {
  const RadioScheduleScreen({super.key});

  @override
  State<RadioScheduleScreen> createState() => _RadioScheduleScreenState();
}

class _RadioScheduleScreenState extends State<RadioScheduleScreen> {
  String _frequency = '3 diffusions par jour';

  final List<String> _selectedSlots = [
    '07h00 - 09h00',
    '12h00 - 14h00',
    '17h00 - 19h00',
  ];

  final List<String> _availableSlots = [
    '05h00 - 07h00',
    '09h00 - 12h00',
    '14h00 - 17h00',
    '19h00 - 22h00',
  ];

  final List<String> _weekDays = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim',
  ];
  final Set<String> _selectedDays = {'Lun', 'Mar', 'Mer', 'Jeu'};

  final String _startDate = '25 mai 2024';
  final String _endDate = '25 juin 2024';

  // ===========================================================
  // ACTIONS
  // ===========================================================

  void _addSlot(String slot) {
    setState(() {
      _selectedSlots.add(slot);
      _availableSlots.remove(slot);
    });
  }

  void _removeSlot(String slot) {
    setState(() {
      _selectedSlots.remove(slot);
      _availableSlots.add(slot);
    });
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
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
              step: 4,
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
                    _buildFieldLabel('Fréquence de diffusion'),
                    const SizedBox(height: 6),
                    _buildFrequencyField(),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Créneaux horaires'),
                    const SizedBox(height: 6),
                    _buildSelectedSlots(),

                    const SizedBox(height: 8),

                    _buildAvailableSlotsList(),

                    const SizedBox(height: 12),

                    _buildFieldLabel('Jours de diffusion'),
                    const SizedBox(height: 6),
                    _buildDaysRow(),

                    const SizedBox(height: 16),

                    _buildFieldLabel('Période de diffusion'),
                    const SizedBox(height: 6),
                    _buildDateRangeField(),
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
  // LABEL DE CHAMP
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

  // ===========================================================
  // FRÉQUENCE
  // ===========================================================

  Widget _buildFrequencyField() {
    return GestureDetector(
      onTap: () async {
        final selected = await _showOptionsSheet(
          title: 'Fréquence de diffusion',
          options: const [
            '1 diffusion par jour',
            '2 diffusions par jour',
            '3 diffusions par jour',
            '4 diffusions par jour',
          ],
        );

        if (selected != null) {
          setState(() => _frequency = selected);
        }
      },

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
              _frequency,

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // CRÉNEAUX SÉLECTIONNÉS (chips bleus supprimables)
  // ===========================================================

  Widget _buildSelectedSlots() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children: [
        ..._selectedSlots.map(
          (slot) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  slot,

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: () => _removeSlot(slot),

                  child: const Icon(
                    Icons.close,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () async {
            if (_availableSlots.isEmpty) return;

            final selected = await _showOptionsSheet(
              title: 'Ajouter un créneau',
              options: _availableSlots,
            );

            if (selected != null) _addSlot(selected);
          },

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
                  'Ajouter un créneau',

                  style: TextStyle(fontSize: 12, color: AppColors.gray400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // AUTRES CRÉNEAUX DISPONIBLES
  // ===========================================================

  Widget _buildAvailableSlotsList() {
    if (_availableSlots.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Column(
        children: List.generate(_availableSlots.length, (index) {
          final slot = _availableSlots[index];
          final bool isLast = index == _availableSlots.length - 1;

          return GestureDetector(
            onTap: () => _addSlot(slot),

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(
                          color: Color(0xFFF9FAFB),
                          width: 1.2,
                        ),
                      ),
              ),

              child: Text(
                slot,

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ===========================================================
  // JOURS DE DIFFUSION
  // ===========================================================

  Widget _buildDaysRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,

      children: _weekDays.map((day) {
        final bool selected = _selectedDays.contains(day);

        return GestureDetector(
          onTap: () => _toggleDay(day),

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: selected ? AppColors.black : AppColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              day,

              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.gray500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ===========================================================
  // PÉRIODE
  // ===========================================================

  Widget _buildDateRangeField() {
    return Row(
      children: [
        Expanded(child: _buildDateBox('Du', _startDate)),
        const SizedBox(width: 8),
        Expanded(child: _buildDateBox('Au', _endDate)),
      ],
    );
  }

  Widget _buildDateBox(String label, String date) {
    return GestureDetector(
      onTap: () async {
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        // TODO: mettre à jour la date choisie une fois le format défini
      },

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        ),

        child: Row(
          children: [
            Text(
              label,

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.gray400,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                date,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BOTTOM SHEET DE SÉLECTION GÉNÉRIQUE
  // ===========================================================

  Future<String?> _showOptionsSheet({
    required String title,
    required List<String> options,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Padding(
                padding: const EdgeInsets.all(16),

                child: Text(
                  title,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),

              ...options.map(
                (option) => ListTile(
                  title: Text(option, style: const TextStyle(fontSize: 14)),
                  onTap: () => Navigator.pop(context, option),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
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
              MaterialPageRoute(builder: (_) => const RadioRecapScreen()),
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
