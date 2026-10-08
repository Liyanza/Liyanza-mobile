import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_exceptions.dart';
import '../../core/providers/account_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/account/account_models.dart';
import 'profil.dart';

/// Fiche de l'entreprise : modifiable par son administrateur, en lecture
/// seule pour les autres rôles.
class CompanyScreen extends ConsumerStatefulWidget {
  final CompanyModel company;
  final bool canEdit;

  const CompanyScreen({super.key, required this.company, required this.canEdit});

  @override
  ConsumerState<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.company.name);
  late final _sector = TextEditingController(text: widget.company.businessSector);
  late final _address = TextEditingController(text: widget.company.address);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _sector.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(accountRemoteDatasourceProvider).updateCompany(
            widget.company.id,
            name: _name.text.trim(),
            businessSector: _sector.text.trim(),
            address: _address.text.trim(),
          );
      ref.invalidate(accountProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entreprise mise à jour.')));
      Navigator.pop(context);
    } on AppException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? required(String? value) =>
        (value == null || value.trim().isEmpty) ? 'Champ obligatoire' : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(title: 'Mon entreprise'),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _Field(label: "NOM DE L'ENTREPRISE", controller: _name, enabled: widget.canEdit, validator: required),
                    _Field(label: "SECTEUR D'ACTIVITÉ", controller: _sector, enabled: widget.canEdit, validator: required),
                    _Field(label: 'ADRESSE', controller: _address, enabled: widget.canEdit, validator: required),
                    if (!widget.canEdit)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "Seul l'administrateur de l'entreprise peut modifier ces informations.",
                          style: TextStyle(fontSize: 11.5, color: AppColors.gray400),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (widget.canEdit)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: AppColors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                        : const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;

  const _Field({required this.label, required this.controller, required this.enabled, required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.gray400, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            enabled: enabled,
            validator: validator,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFF3F4F6))),
            ),
          ),
        ],
      ),
    );
  }
}
