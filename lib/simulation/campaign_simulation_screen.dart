import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/theme/kiyanza_colors.dart';
import '../core/network/app_exceptions.dart';
import '../core/providers/simulation_providers.dart';
import '../data/models/simulation/simulation_models.dart';

class CampaignSimulationScreen extends ConsumerStatefulWidget {
  final String campaignId;
  final String campaignName;

  const CampaignSimulationScreen({
    super.key,
    required this.campaignId,
    required this.campaignName,
  });

  @override
  ConsumerState<CampaignSimulationScreen> createState() => _CampaignSimulationScreenState();
}

class _CampaignSimulationScreenState extends ConsumerState<CampaignSimulationScreen> {
  bool _isLoadingQuestions = true;
  bool _isSubmitting = false;
  List<SimulationQuestionModel> _questions = [];
  List<SimulationModel> _history = [];
  final Map<String, TextEditingController> _controllers = {};
  final _dateFormat = DateFormat('dd/MM/yyyy à HH:mm');

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoadingQuestions = true);
    try {
      final repo = ref.read(simulationRepositoryProvider);
      final results = await Future.wait([repo.getQuestions(), repo.getHistory(widget.campaignId)]);
      final questions = results[0] as List<SimulationQuestionModel>;
      final history = results[1] as List<SimulationModel>;
      for (final q in questions) {
        _controllers[q.id] = TextEditingController();
      }
      setState(() {
        _questions = questions;
        _history = history;
      });
    } on AppException catch (e) {
      if (mounted) _showSnack(e.message);
    } finally {
      if (mounted) setState(() => _isLoadingQuestions = false);
    }
  }

  void _showSnack(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _handleSubmit() async {
    final reponses = <SimulationAnswerInput>[];
    for (final q in _questions) {
      final value = _controllers[q.id]!.text.trim();
      if (value.isEmpty) {
        _showSnack('Merci de répondre à toutes les questions.');
        return;
      }
      // Aligné sur @MaxLength(2000) de ReponseDto (soumettre-reponses.dto.ts).
      if (value.length > 2000) {
        _showSnack('Une réponse dépasse 2000 caractères.');
        return;
      }
      reponses.add(SimulationAnswerInput(questionId: q.id, value: value));
    }

    setState(() => _isSubmitting = true);
    try {
      final simulation = await ref
          .read(simulationRepositoryProvider)
          .submit(widget.campaignId, SubmitSimulationRequest(reponses));
      setState(() {
        _history = [simulation, ..._history];
        for (final c in _controllers.values) {
          c.clear();
        }
      });
      if (mounted) _showSnack('Simulation générée avec succès.');
    } on AppException catch (e) {
      final message = e is ValidationFailedException && e.details.isNotEmpty
          ? e.details.join('\n')
          : e.message;
      if (mounted) _showSnack(message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoadingQuestions
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_questions.isEmpty) _buildNoQuestionsNotice() else _buildForm(),
                          if (_history.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            const Text('Simulations précédentes',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            ..._history.map(_buildHistoryCard),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Simuler — ${widget.campaignName}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsNotice() {
    // Aucune question configurée côté backend (table Question vide) — voir
    // étape 1 du guide plutôt que de laisser un écran vide et silencieux.
    return const Text(
      "Aucune question de simulation n'est configurée pour l'instant. "
      "Réessayez plus tard.",
      style: TextStyle(fontSize: 12, color: AppColors.gray500),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final q in _questions) ...[
          Text(q.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: _controllers[q.id],
            keyboardType: q.fieldType == 'number' ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.gray100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, elevation: 0),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                  )
                : const Text('Lancer la simulation', style: TextStyle(color: AppColors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(SimulationModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_dateFormat.format(s.simulatedAt),
              style: const TextStyle(fontSize: 10, color: AppColors.gray400)),
          const SizedBox(height: 6),
          Text('Budget estimé : ${s.estimatedBudget.toStringAsFixed(0)} FCFA',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(s.expectedResults, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
        ],
      ),
    );
  }
}