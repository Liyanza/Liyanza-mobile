import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_exceptions.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import 'profil.dart';

/// Changement de mot de passe : un lien sécurisé est envoyé par email
/// (POST /auth/forgot-password), le nouveau mot de passe se choisit sur
/// kiyanza.com. Un compte créé avec Google y définit son premier mot de passe.
class SecurityScreen extends ConsumerStatefulWidget {
  final String email;

  const SecurityScreen({super.key, required this.email});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  bool _sending = false;
  bool _sent = false;

  Future<void> _sendLink() async {
    setState(() => _sending = true);
    try {
      await ref.read(authRepositoryProvider).forgotPassword(widget.email);
      if (mounted) setState(() => _sent = true);
    } on AppException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(title: 'Sécurité'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MOT DE PASSE',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gray400, letterSpacing: 0.7),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _sent
                              ? 'Un lien a été envoyé à ${widget.email}. Ouvrez-le pour choisir votre nouveau mot de passe (valable 30 minutes).'
                              : 'Recevez par email un lien sécurisé pour changer votre mot de passe, ou en définir un si vous vous connectez avec Google.',
                          style: const TextStyle(fontSize: 13, color: AppColors.gray600, height: 1.45),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _sending ? null : _sendLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              foregroundColor: AppColors.white,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                            child: _sending
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                                : Text(_sent ? 'Renvoyer le lien' : 'Recevoir le lien'),
                          ),
                        ),
                      ],
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
