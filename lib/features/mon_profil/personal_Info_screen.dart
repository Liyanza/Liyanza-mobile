import 'package:flutter/material.dart';

import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/account/account_models.dart';
import 'profil.dart';

/// Informations du compte, en lecture seule : elles se modifient en
/// contactant l'administrateur de l'entreprise.
class PersonalInfoScreen extends StatelessWidget {
  final ProfileModel profile;

  const PersonalInfoScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final created = profile.createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(title: 'Informations personnelles'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _Card(title: 'IDENTITÉ', rows: [
                    ('PRÉNOM', profile.firstName.isNotEmpty ? profile.firstName : '—'),
                    ('NOM', profile.lastName.isNotEmpty ? profile.lastName : '—'),
                  ]),
                  _Card(title: 'CONTACT', rows: [
                    ('EMAIL', profile.email),
                    ('TÉLÉPHONE', profile.phone ?? '—'),
                  ]),
                  _Card(title: 'POSTE', rows: [
                    ('RÔLE', userRoleLabel(profile.role)),
                    ('MEMBRE DEPUIS', '${two(created.day)}/${two(created.month)}/${created.year}'),
                  ]),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      "Pour modifier ces informations, contactez l'administrateur de votre entreprise.",
                      style: TextStyle(fontSize: 11.5, color: AppColors.gray400, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _Card({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gray400, letterSpacing: 0.7)),
          const SizedBox(height: 6),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.gray400)),
                  const SizedBox(height: 2),
                  SelectableText(value, style: const TextStyle(fontSize: 13.5, color: AppColors.black)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
