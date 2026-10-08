import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/main_navigation.dart';
import '../../core/network/app_exceptions.dart';
import '../../core/providers/account_providers.dart';
import '../../core/providers/dashboard_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import 'auth_form_scaffold.dart';

/// Création de l'entreprise (POST /entreprises) : l'utilisateur en devient
/// l'administrateur. Le backend relit le rôle à chaque requête, la session
/// en cours suffit.
class CreateCompanyScreen extends ConsumerStatefulWidget {
  /// Juste après l'inscription : pas de retour arrière, mais « Plus tard ».
  final bool afterSignUp;

  const CreateCompanyScreen({super.key, this.afterSignUp = false});

  @override
  ConsumerState<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends ConsumerState<CreateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _sector = TextEditingController();
  final _address = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _sector.dispose();
    _address.dispose();
    super.dispose();
  }

  void _goHome() {
    ref.invalidate(meProvider);
    ref.invalidate(accountProvider);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(accountRemoteDatasourceProvider).createCompany(
            name: _name.text.trim(),
            businessSector: _sector.text.trim(),
            address: _address.text.trim(),
          );
      if (mounted) _goHome();
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e is ConflictException ? 'Votre compte est déjà rattaché à une entreprise.' : e.message),
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null;

    return AuthFormScaffold(
      title: 'Votre entreprise',
      subtitle: "Dernière étape : vos campagnes, votre équipe et l'IA s'appuient dessus",
      showBack: !widget.afterSignUp,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _name,
              label: "Nom de l'entreprise",
              validator: required,
              textCapitalization: TextCapitalization.words,
            ),
            AuthTextField(
              controller: _sector,
              label: "Secteur d'activité (ex. Commerce, Restauration)",
              validator: required,
              textCapitalization: TextCapitalization.sentences,
            ),
            AuthTextField(
              controller: _address,
              label: 'Adresse (ville, quartier)',
              validator: required,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
            ),
            const Text(
              "Vous en serez l'administrateur et pourrez inviter votre équipe depuis kiyanza.com.",
              style: TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
            ),
            const SizedBox(height: 16),
            AuthPrimaryButton(label: "Créer l'entreprise", loading: _loading, onPressed: _submit),
            if (widget.afterSignUp) ...[
              const SizedBox(height: 4),
              TextButton(
                onPressed: _loading ? null : _goHome,
                child: const Text(
                  'Plus tard (si vous attendez une invitation)',
                  style: TextStyle(fontSize: 12.5, color: AppColors.gray500),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
