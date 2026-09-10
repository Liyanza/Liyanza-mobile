import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  bool isEditing = false;

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),

                child: Column(
                  children: [
                    _buildLogo(),

                    const SizedBox(height: 8),

                    const Text(
                      'Logo de l’entreprise',

                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),

                    const SizedBox(height: 16),

                    _buildCompanyCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),

          const SizedBox(width: 16),

          const Text(
            'Mon entreprise',

            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // LOGO
  // ===========================================================

  Widget _buildLogo() {
    return Container(
      width: 64,
      height: 64,

      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(18),
      ),

      child: const Center(
        child: Text(
          'BO',

          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // CARD
  // ===========================================================

  Widget _buildCompanyCard() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        children: [
          if (isEditing) _buildEditActions(),

          _buildField(label: 'NOM DE L’ENTREPRISE', value: 'Boutique Orange'),

          _buildField(label: 'SECTEUR D’ACTIVITÉ', value: 'Télécommunications'),

          _buildField(label: 'VILLE', value: 'Douala'),

          _buildField(label: 'PAYS', value: 'Cameroun'),

          _buildField(label: 'ADRESSE', value: 'Rue Joss, Akwa'),

          _buildField(label: 'N° RCCM / SIREN', value: 'CM-2019-00456'),

          _buildField(label: 'SITE WEB', value: 'orange.cm'),

          _buildField(label: 'EFFECTIF', value: '51–200 employés'),
        ],
      ),
    );
  }

  // ===========================================================
  // FIELD
  // ===========================================================

  Widget _buildField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  label,

                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray400,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              setState(() {
                isEditing = true;
              });
            },

            child: Container(
              width: 30,
              height: 30,

              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.edit_outlined,
                size: 14,
                color: AppColors.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // ACTIONS
  // ===========================================================

  Widget _buildEditActions() {
    return Padding(
      padding: const EdgeInsets.all(12),

      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gray100,
                elevation: 0,
              ),

              child: const Text(
                'Annuler',
                style: TextStyle(color: AppColors.gray500),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                elevation: 0,
              ),

              child: const Text(
                'Enregistrer',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
