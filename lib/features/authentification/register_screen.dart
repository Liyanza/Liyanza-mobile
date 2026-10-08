import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_exceptions.dart';
import '../../core/providers/auth_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import 'auth_form_scaffold.dart';
import 'create_company_screen.dart';

/// Inscription (POST /auth/register), puis connexion automatique et
/// création de l'entreprise.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _phone, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final email = _email.text.trim();
    try {
      await ref.read(authRepositoryProvider).register(
            email: email,
            password: _password.text,
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            phone: _phone.text.trim(),
          );
      await ref.read(authNotifierProvider.notifier).login(email, _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const CreateCompanyScreen(afterSignUp: true)),
        (route) => false,
      );
    } on ValidationFailedException catch (e) {
      _showSnack(e.details.join('\n'));
    } on AppException catch (e) {
      _showSnack(e is EmailAlreadyUsedException
          ? 'Un compte existe déjà avec cet email. Connectez-vous, ou utilisez « Mot de passe oublié ».'
          : e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null;

    return AuthFormScaffold(
      title: 'Créez votre compte',
      subtitle: 'Gratuit, sans carte bancaire',
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AuthTextField(
                      controller: _firstName,
                      label: 'Prénom',
                      validator: required,
                      autofillHints: const [AutofillHints.givenName],
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AuthTextField(
                      controller: _lastName,
                      label: 'Nom',
                      validator: required,
                      autofillHints: const [AutofillHints.familyName],
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              AuthTextField(
                controller: _email,
                label: 'Email professionnel',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Champ obligatoire';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Email invalide';
                  return null;
                },
              ),
              AuthTextField(
                controller: _phone,
                label: 'Téléphone (ex. +237 6XX XX XX XX)',
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                validator: (v) {
                  final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                  if (digits.isEmpty) return 'Champ obligatoire';
                  if (digits.length < 8) return 'Numéro trop court';
                  return null;
                },
              ),
              AuthTextField(
                controller: _password,
                label: 'Mot de passe (8 caractères minimum)',
                obscure: _obscure,
                autofillHints: const [AutofillHints.newPassword],
                suffix: IconButton(
                  tooltip: _obscure ? 'Afficher le mot de passe' : 'Masquer le mot de passe',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
                ),
                validator: (v) => (v == null || v.length < 8) ? '8 caractères minimum' : null,
              ),
              AuthTextField(
                controller: _confirm,
                label: 'Confirmer le mot de passe',
                obscure: _obscure,
                textInputAction: TextInputAction.done,
                validator: (v) => v != _password.text ? 'Les mots de passe ne correspondent pas' : null,
              ),
              const SizedBox(height: 4),
              const Text(
                "En créant un compte, vous acceptez les conditions d'utilisation et la politique de confidentialité de Kiyanza (kiyanza.com).",
                style: TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
              ),
              const SizedBox(height: 16),
              AuthPrimaryButton(label: 'Créer mon compte', loading: _loading, onPressed: _submit),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Déjà un compte ? ', style: TextStyle(fontSize: 12.5, color: Color(0xFF6C7278))),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
