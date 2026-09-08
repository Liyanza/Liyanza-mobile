import 'package:flutter/material.dart';

import '../../../core/theme/kiyanza_colors.dart';
import 'radio_campaign_details_screen.dart';
import 'radio_step_header.dart';

class RadioStationScreen extends StatefulWidget {
  const RadioStationScreen({super.key});

  @override
  State<RadioStationScreen> createState() => _RadioStationScreenState();
}

class _RadioStationScreenState extends State<RadioStationScreen> {
  int _selectedIndex = 0; // 'Radio Balafon' sélectionnée par défaut
  String _searchQuery = '';

  final List<_RadioStation> _stations = [
    _RadioStation(name: 'Radio Balafon', coverage: 'Couverture nationale'),
    _RadioStation(name: 'Radio Campus', coverage: 'Couverture nationale'),
    _RadioStation(name: 'Africa N°1', coverage: 'Couverture nationale'),
    _RadioStation(name: 'Sweet FM', coverage: 'Couverture Douala'),
    _RadioStation(name: 'Urban FM', coverage: 'Couverture Yaoundé'),
  ];

  List<_RadioStation> get _filteredStations {
    if (_searchQuery.isEmpty) return _stations;

    return _stations
        .where(
          (station) =>
              station.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
              step: 1,
              totalSteps: 5,
            ),

            // =================================================
            // CONTENU
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Sur quelle radio souhaitez-vous communiquer ?',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Sélectionnez la station de diffusion principale.',

                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.gray400,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildSearchField(),

                    const SizedBox(height: 16),

                    ...List.generate(_filteredStations.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildStationCard(index),
                      );
                    }),
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
  // RECHERCHE
  // ===========================================================

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),

      child: Row(
        children: [
          const Icon(Icons.search, size: 15, color: AppColors.gray400),

          const SizedBox(width: 8),

          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },

              decoration: const InputDecoration(
                hintText: 'Rechercher une radio...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.gray400),
                border: InputBorder.none,
                isDense: true,
              ),

              style: const TextStyle(fontSize: 13, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // CARTE STATION
  // ===========================================================

  Widget _buildStationCard(int index) {
    final station = _filteredStations[index];
    final bool selected = _stations.indexOf(station) == _selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = _stations.indexOf(station);
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFAFAFA) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        ),

        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(12),
              ),

              child: const Icon(Icons.radio, size: 16, color: AppColors.black),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    station.name,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    station.coverage,

                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 20,
              height: 20,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.black : AppColors.white,
                border: Border.all(
                  color: selected ? AppColors.black : const Color(0xFFE5E7EB),
                  width: 1.2,
                ),
              ),

              child: selected
                  ? const Icon(Icons.circle, size: 8, color: AppColors.white)
                  : null,
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),

      child: SizedBox(
        width: double.infinity,
        height: 53,

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RadioCampaignDetailsScreen(),
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

// =============================================================
// MODEL
// =============================================================

class _RadioStation {
  final String name;
  final String coverage;

  _RadioStation({required this.name, required this.coverage});
}
