import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_exceptions.dart';
import '../../core/providers/account_providers.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/account/account_models.dart';
import '../../data/models/auth/auth_models.dart';
import '../authentification/login_screen.dart';

import 'company_screen.dart';
import 'personal_Info_screen.dart';
import 'security_screen.dart';

const supportEmail = 'contact@kiyanza.com';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(title: 'Mon profil'),
            Expanded(
              child: account.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          error is AppException ? error.message : 'Impossible de charger votre profil.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.gray500),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => ref.invalidate(accountProvider),
                          child: const Text('Réessayer'),
                        ),
                        const SizedBox(height: 24),
                        _LogoutButton(ref: ref),
                      ],
                    ),
                  ),
                ),
                data: (data) => RefreshIndicator(
                  onRefresh: () => ref.refresh(accountProvider.future),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      children: [
                        _Identity(profile: data.profile),
                        const SizedBox(height: 20),
                        _Section(
                          title: 'MON ENTREPRISE',
                          children: [
                            if (data.company == null)
                              const Padding(
                                padding: EdgeInsets.fromLTRB(14, 4, 14, 14),
                                child: Text(
                                  "Aucune entreprise : créez-la sur kiyanza.com ou demandez une invitation à votre administrateur.",
                                  style: TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
                                ),
                              )
                            else
                              _MenuItem(
                                icon: Icons.business_outlined,
                                title: data.company!.name,
                                subtitle: data.company!.businessSector,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanyScreen(
                                      company: data.company!,
                                      canEdit: data.profile.role == UserRole.admin,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'COMPTE',
                          children: [
                            _MenuItem(
                              icon: Icons.person_outline,
                              title: 'Informations personnelles',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PersonalInfoScreen(profile: data.profile)),
                              ),
                            ),
                            _MenuItem(
                              icon: Icons.lock_outline,
                              title: 'Sécurité',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => SecurityScreen(email: data.profile.email)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'SUPPORT',
                          children: [
                            _MenuItem(
                              icon: Icons.mail_outline,
                              title: 'Nous contacter',
                              subtitle: supportEmail,
                              onTap: () => showDialog<void>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Nous contacter'),
                                  content: const SelectableText(
                                    'Écrivez-nous à $supportEmail : nous répondons sous 24 h ouvrées.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _MenuItem(
                              icon: Icons.info_outline,
                              title: 'À propos de KIYANZA',
                              onTap: () => showAboutDialog(
                                context: context,
                                applicationName: 'Kiyanza',
                                applicationVersion: '1.0.0',
                                applicationLegalese: '© Kiyanza — kiyanza.com',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _LogoutButton(ref: ref),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// En-tête commun aux écrans du profil : retour + titre centré.
class ProfileHeader extends StatelessWidget {
  final String title;

  const ProfileHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1))),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Retour',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.black),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.black),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  final ProfileModel profile;

  const _Identity({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(18)),
          child: Center(
            child: Text(
              profile.initials,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          profile.fullName.isNotEmpty ? profile.fullName : profile.email,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.black),
        ),
        const SizedBox(height: 4),
        Text(userRoleLabel(profile.role), style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
        const SizedBox(height: 3),
        Text(profile.email, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.gray400,
                letterSpacing: 0.7,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.gray500),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.black)),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!, style: const TextStyle(fontSize: 10, color: AppColors.gray400)),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final WidgetRef ref;

  const _LogoutButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () async {
          await ref.read(authNotifierProvider.notifier).logout();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDC2626),
          side: const BorderSide(color: Color(0xFFFECACA)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('Se déconnecter', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
