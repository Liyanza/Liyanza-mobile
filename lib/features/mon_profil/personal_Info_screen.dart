import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
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
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    _buildAvatar(),

                    const SizedBox(height: 8),

                    const Text(
                      'Appuyer pour modifier la photo',

                      style: TextStyle(fontSize: 10, color: AppColors.gray400),
                    ),

                    const SizedBox(height: 16),

                    _buildIdentityCard(),

                    const SizedBox(height: 10),

                    _buildContactCard(),

                    const SizedBox(height: 10),

                    _buildRoleCard(),
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

      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),

            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),

          const SizedBox(width: 16),

          const Text(
            'Informations personnelles',

            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // AVATAR
  // ===========================================================

  Widget _buildAvatar() {
    return Container(
      width: 64,
      height: 64,

      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(18),
      ),

      child: const Center(
        child: Text(
          'AN',

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // IDENTITY
  // ===========================================================

  Widget _buildIdentityCard() {
    return _buildCard(
      title: 'IDENTITÉ',

      children: [
        _buildInfoRow('PRÉNOM', 'Aristide'),

        _buildInfoRow('NOM', 'Nna'),
      ],
    );
  }

  // ===========================================================
  // CONTACT
  // ===========================================================

  Widget _buildContactCard() {
    return _buildCard(
      title: 'CONTACT',

      children: [
        _buildInfoRow('EMAIL', 'aristide@gmail.com'),

        _buildInfoRow('TÉLÉPHONE', '+237 699 000 111'),
      ],
    );
  }

  // ===========================================================
  // ROLE
  // ===========================================================

  Widget _buildRoleCard() {
    return _buildCard(
      title: 'POSTE',

      children: [_buildInfoRow('RÔLE', 'Responsable Marketing')],
    );
  }

  // ===========================================================
  // CARD
  // ===========================================================

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray400,
                ),
              ),
            ),
          ),

          ...children,
        ],
      ),
    );
  }

  // ===========================================================
  // INFO ROW
  // ===========================================================

  Widget _buildInfoRow(String label, String value) {
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
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,

                  style: const TextStyle(fontSize: 12, color: AppColors.black),
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

            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: AppColors.gray400,
            ),
          ),
        ],
      ),
    );
  }
}
