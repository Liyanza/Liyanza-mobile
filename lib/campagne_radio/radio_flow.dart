import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../campagnes/campagne.dart';
import '../campagnes/campagne_detail.dart';
import '../core/network/app_exceptions.dart';
import '../core/providers/campagne_providers.dart';
import '../core/providers/campaign_detail_providers.dart';
import '../core/providers/dashboard_providers.dart';
import '../core/theme/kiyanza_colors.dart';
import '../data/models/campagnes/campagne_models.dart';
import '../data/models/campagnes/campaign_creation_models.dart';
import '../data/models/campagnes/radio_draft.dart';
import 'radio_step_header.dart';

// Parcours de création d'une campagne radio : chaque écran complète le
// même RadioDraft, le récapitulatif crée la campagne, son canal radio et
// son planning de diffusions (mêmes appels que l'assistant du site).

const _title = 'Nouvelle campagne radio';
const _steps = 5;

class _StepScaffold extends StatelessWidget {
  final int step;
  final Widget body;
  final String buttonLabel;
  final VoidCallback? onContinue;
  final bool busy;

  const _StepScaffold({
    required this.step,
    required this.body,
    required this.buttonLabel,
    required this.onContinue,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            RadioStepHeader(title: _title, step: step, totalSteps: _steps),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: body,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  onPressed: busy ? null : onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: busy
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white))
                      : Text(buttonLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _Heading(this.title, [this.subtitle]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.black)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(fontSize: 13, color: AppColors.gray500)),
          ],
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.black)),
    );
  }
}

InputDecoration _inputDecoration({String? hint, String? suffix}) => InputDecoration(
      hintText: hint,
      suffixText: suffix,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.green)),
    );

/// Choix exclusifs en pastilles.
class _ChoiceChips<T> extends StatelessWidget {
  final List<(T, String)> options;
  final bool Function(T) isSelected;
  final void Function(T) onTap;

  const _ChoiceChips({required this.options, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (value, label) in options)
          ChoiceChip(
            label: Text(label),
            selected: isSelected(value),
            onSelected: (_) => onTap(value),
            selectedColor: AppColors.green.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: isSelected(value) ? const Color(0xFF15803D) : AppColors.gray600,
            ),
            showCheckmark: false,
            side: BorderSide(color: isSelected(value) ? AppColors.green : const Color(0xFFE5E7EB)),
            shape: const StadiumBorder(),
          ),
      ],
    );
  }
}

// =============================================================
// 1. STATION
// =============================================================

const _stations = [
  ('CRTV Radio', 'Couverture nationale'),
  ('Radio Balafon', 'Douala'),
  ('Sweet FM', 'Douala'),
  ('Radio Equinoxe', 'Douala'),
  ('Magic FM', 'Yaoundé'),
  ('Radio Siantou', 'Yaoundé'),
];

class RadioStationScreen extends StatefulWidget {
  const RadioStationScreen({super.key});

  @override
  State<RadioStationScreen> createState() => _RadioStationScreenState();
}

class _RadioStationScreenState extends State<RadioStationScreen> {
  final _draft = RadioDraft();
  final _custom = TextEditingController();
  String _query = '';
  int? _selected;

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  bool get _valid => _selected != null || _custom.text.trim().isNotEmpty;

  void _continue() {
    if (_selected != null) {
      _draft.station = _stations[_selected!].$1;
      _draft.stationCoverage = _stations[_selected!].$2;
    } else {
      _draft.station = _custom.text.trim();
      _draft.stationCoverage = '';
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => RadioDetailsScreen(draft: _draft)));
  }

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (var i = 0; i < _stations.length; i++)
        if (_query.isEmpty || _stations[i].$1.toLowerCase().contains(_query.toLowerCase())) i,
    ];
    return _StepScaffold(
      step: 1,
      buttonLabel: 'Continuer',
      onContinue: _valid ? _continue : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading('Sur quelle radio souhaitez-vous communiquer ?', 'Choisissez la station principale de diffusion.'),
          TextField(
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: _inputDecoration(hint: 'Rechercher une radio…').copyWith(prefixIcon: const Icon(Icons.search)),
          ),
          const SizedBox(height: 12),
          for (final i in visible)
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: _selected == i ? AppColors.green : const Color(0xFFE5E7EB)),
              ),
              child: ListTile(
                leading: const Icon(Icons.radio_outlined, color: AppColors.orange),
                title: Text(_stations[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_stations[i].$2),
                trailing: _selected == i ? const Icon(Icons.check_circle, color: AppColors.green) : null,
                onTap: () => setState(() {
                  _selected = i;
                  _custom.clear();
                }),
              ),
            ),
          const _Label('Votre radio n’est pas dans la liste ?'),
          TextField(
            controller: _custom,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() => _selected = null),
            decoration: _inputDecoration(hint: 'Nom de la station'),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 2. INFORMATIONS
// =============================================================

const _radioObjectives = ['Notoriété', 'Lancement de produit', 'Promotion', 'Événement', 'Fidélisation'];
const _zones = ['Nationale', 'Douala', 'Yaoundé', 'Ouest', 'Nord', 'Autre'];

String _fmtDay(DateTime d) => formatDay(d);

class RadioDetailsScreen extends StatefulWidget {
  final RadioDraft draft;

  const RadioDetailsScreen({super.key, required this.draft});

  @override
  State<RadioDetailsScreen> createState() => _RadioDetailsScreenState();
}

class _RadioDetailsScreenState extends State<RadioDetailsScreen> {
  late final _name = TextEditingController(
    text: widget.draft.name.isNotEmpty ? widget.draft.name : 'Campagne ${widget.draft.station}',
  );
  late final _budget = TextEditingController(text: '${widget.draft.budget}');
  late final _target = TextEditingController(text: widget.draft.target);

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    _target.dispose();
    super.dispose();
  }

  int get _budgetValue => int.tryParse(_budget.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  bool get _valid =>
      _name.text.trim().isNotEmpty && _budgetValue > 0 && !widget.draft.endDate.isBefore(widget.draft.startDate);

  Future<void> _pickDate({required bool start}) async {
    final draft = widget.draft;
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: start ? draft.startDate : draft.endDate,
      firstDate: start ? DateTime(today.year, today.month, today.day) : draft.startDate,
      lastDate: DateTime(today.year + 2),
      helpText: start ? 'Début de la diffusion' : 'Fin de la diffusion',
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        draft.startDate = picked;
        if (draft.endDate.isBefore(picked)) draft.endDate = picked.add(const Duration(days: 29));
      } else {
        draft.endDate = picked;
      }
    });
  }

  void _continue() {
    final draft = widget.draft
      ..name = _name.text.trim()
      ..budget = _budgetValue
      ..target = _target.text.trim();
    Navigator.push(context, MaterialPageRoute(builder: (_) => RadioSpotScreen(draft: draft)));
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    Widget dateBox(String label, DateTime date, bool start) => Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _pickDate(start: start),
            child: InputDecorator(
              decoration: _inputDecoration().copyWith(labelText: label),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.green),
                  const SizedBox(width: 8),
                  Flexible(child: Text(_fmtDay(date), style: const TextStyle(fontSize: 13.5))),
                ],
              ),
            ),
          ),
        );

    return _StepScaffold(
      step: 2,
      buttonLabel: 'Continuer',
      onContinue: _valid ? _continue : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading('Votre campagne sur ${draft.station}'),
          const _Label('Nom de la campagne'),
          TextField(
            controller: _name,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(),
          ),
          const _Label('Objectif'),
          _ChoiceChips<String>(
            options: [for (final o in _radioObjectives) (o, o)],
            isSelected: (o) => draft.objective == o,
            onTap: (o) => setState(() => draft.objective = o),
          ),
          const _Label('Budget total'),
          TextField(
            controller: _budget,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(suffix: 'FCFA'),
          ),
          const _Label('Période de diffusion'),
          Row(children: [dateBox('Du', draft.startDate, true), const SizedBox(width: 10), dateBox('Au', draft.endDate, false)]),
          const _Label('Zone de diffusion'),
          _ChoiceChips<String>(
            options: [for (final z in _zones) (z, z)],
            isSelected: (z) => draft.zone == z,
            onTap: (z) => setState(() => draft.zone = z),
          ),
          const _Label('Cible principale (facultatif)'),
          TextField(
            controller: _target,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(hint: 'Ex. Mères de famille, 25-45 ans'),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 3. SPOT
// =============================================================

class RadioSpotScreen extends StatefulWidget {
  final RadioDraft draft;

  const RadioSpotScreen({super.key, required this.draft});

  @override
  State<RadioSpotScreen> createState() => _RadioSpotScreenState();
}

class _RadioSpotScreenState extends State<RadioSpotScreen> {
  late final _spotName = TextEditingController(text: widget.draft.spotName);

  @override
  void dispose() {
    _spotName.dispose();
    super.dispose();
  }

  void _continue() {
    widget.draft.spotName = _spotName.text.trim();
    Navigator.push(context, MaterialPageRoute(builder: (_) => RadioScheduleScreen(draft: widget.draft)));
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    return _StepScaffold(
      step: 3,
      buttonLabel: 'Continuer',
      onContinue: _spotName.text.trim().isNotEmpty ? _continue : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading('Votre spot radio', 'Sa durée sert à planifier chaque diffusion.'),
          const _Label('Nom du spot'),
          TextField(
            controller: _spotName,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration(hint: 'Ex. Promo rentrée 30 s'),
          ),
          const _Label('Durée du spot'),
          _ChoiceChips<int>(
            options: const [(15, '15 s'), (30, '30 s'), (45, '45 s'), (60, '60 s')],
            isSelected: (s) => draft.spotSeconds == s,
            onTap: (s) => setState(() => draft.spotSeconds = s),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.gray500),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Le fichier audio (MP3, WAV) se joint à la campagne depuis kiyanza.com ou se remet directement à la radio.',
                    style: TextStyle(fontSize: 12, color: AppColors.gray600, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 4. PLANNING
// =============================================================

class RadioScheduleScreen extends StatefulWidget {
  final RadioDraft draft;

  const RadioScheduleScreen({super.key, required this.draft});

  @override
  State<RadioScheduleScreen> createState() => _RadioScheduleScreenState();
}

class _RadioScheduleScreenState extends State<RadioScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final schedule = buildRadioSchedule(draft);
    final valid = draft.slots.isNotEmpty && draft.weekdays.isNotEmpty && schedule.broadcasts.isNotEmpty;

    return _StepScaffold(
      step: 4,
      buttonLabel: 'Voir le récapitulatif',
      onContinue: valid
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => RadioRecapScreen(draft: draft)))
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading('Quand diffuser le spot ?', 'Une diffusion par créneau choisi, chaque jour retenu.'),
          const _Label('Créneaux horaires'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final slot in radioSlotOptions)
                FilterChip(
                  label: Text(slot),
                  selected: draft.slots.contains(slot),
                  onSelected: (on) => setState(() => on ? draft.slots.add(slot) : draft.slots.remove(slot)),
                  selectedColor: AppColors.green.withValues(alpha: 0.15),
                  checkmarkColor: const Color(0xFF15803D),
                  side: BorderSide(color: draft.slots.contains(slot) ? AppColors.green : const Color(0xFFE5E7EB)),
                  shape: const StadiumBorder(),
                ),
            ],
          ),
          const _Label('Jours de diffusion'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final entry in radioWeekdayLabels.entries)
                FilterChip(
                  label: Text(entry.value),
                  selected: draft.weekdays.contains(entry.key),
                  onSelected: (on) => setState(() => on ? draft.weekdays.add(entry.key) : draft.weekdays.remove(entry.key)),
                  selectedColor: AppColors.green.withValues(alpha: 0.15),
                  showCheckmark: false,
                  side: BorderSide(color: draft.weekdays.contains(entry.key) ? AppColors.green : const Color(0xFFE5E7EB)),
                  shape: const StadiumBorder(),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              schedule.broadcasts.isEmpty
                  ? 'Aucune diffusion : choisissez au moins un créneau et un jour compris dans la période.'
                  : '${schedule.broadcasts.length} diffusion${schedule.broadcasts.length > 1 ? 's' : ''} '
                      'du ${_fmtDay(draft.startDate)} au ${_fmtDay(draft.endDate)}'
                      '${schedule.truncated ? ' (plafond de $maxBroadcasts atteint : réduisez la période ou les créneaux)' : ''}.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF15803D), fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 5. RÉCAPITULATIF ET CRÉATION
// =============================================================

class RadioRecapScreen extends ConsumerStatefulWidget {
  final RadioDraft draft;

  const RadioRecapScreen({super.key, required this.draft});

  @override
  ConsumerState<RadioRecapScreen> createState() => _RadioRecapScreenState();
}

class _RadioRecapScreenState extends ConsumerState<RadioRecapScreen> {
  bool _creating = false;

  Future<void> _create() async {
    final draft = widget.draft;
    final schedule = buildRadioSchedule(draft);
    setState(() => _creating = true);
    CampagneModel? campaign;
    try {
      campaign = await ref.read(campagneRepositoryProvider).create(CreateCampagneRequest(
            name: draft.name,
            startDate: draft.startDate,
            endDate: DateTime(draft.endDate.year, draft.endDate.month, draft.endDate.day, 23, 59),
            plannedBudget: draft.budget.toDouble(),
            objective: draft.objectiveText,
            type: CampaignType.radio,
          ));
      final detail = ref.read(campaignDetailRemoteDatasourceProvider);
      final channelId = await detail.createRadioChannel(campaign.id);
      final created = await detail.createSchedule(campaign.id, channelId, schedule.broadcasts);
      ref.invalidate(homeDataProvider);
      await ref.read(campagnesNotifierProvider.notifier).refresh();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => RadioSuccessScreen(draft: draft, campaign: campaign!, broadcastCount: created),
      ));
    } on AppException catch (e) {
      if (!mounted) return;
      final message = e is ValidationFailedException ? e.details.join('\n') : e.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(campaign == null
            ? message
            : 'Campagne créée, mais son planning n’a pas pu être enregistré : $message'),
      ));
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final schedule = buildRadioSchedule(draft);
    final days = (draft.weekdays.toList()..sort()).map((d) => radioWeekdayLabels[d]).join(', ');
    final rows = [
      ('Radio', draft.stationCoverage.isEmpty ? draft.station : '${draft.station} · ${draft.stationCoverage}'),
      ('Campagne', draft.name),
      ('Objectif', draft.objective),
      ('Budget total', formatFcfa(draft.budget.toDouble())),
      ('Période', '${_fmtDay(draft.startDate)} – ${_fmtDay(draft.endDate)}'),
      ('Spot', '${draft.spotName} · ${draft.spotSeconds} s'),
      ('Créneaux', draft.slots.join(', ')),
      ('Jours', days),
      ('Zone', draft.zone),
      if (draft.target.isNotEmpty) ('Cible', draft.target),
      ('Diffusions planifiées', '${schedule.broadcasts.length}'),
    ];

    return _StepScaffold(
      step: 5,
      buttonLabel: 'Créer la campagne',
      busy: _creating,
      onContinue: _create,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading('Récapitulatif', 'Vérifiez avant de créer la campagne.'),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      border: i == rows.length - 1 ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 120, child: Text(rows[i].$1, style: const TextStyle(fontSize: 12.5, color: AppColors.gray500))),
                        Expanded(
                          child: Text(rows[i].$2,
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 6. CONFIRMATION
// =============================================================

class RadioSuccessScreen extends StatelessWidget {
  final RadioDraft draft;
  final CampagneModel campaign;
  final int broadcastCount;

  const RadioSuccessScreen({
    super.key,
    required this.draft,
    required this.campaign,
    required this.broadcastCount,
  });

  void _close(BuildContext context, {required bool openCampaign}) {
    final navigator = Navigator.of(context);
    navigator.popUntil((route) => route.settings.name == campaignTypeRouteName || route.isFirst);
    if (openCampaign) {
      final route = MaterialPageRoute<void>(
        builder: (_) => CampaignDetailScreen(campaign: CampaignItem.fromApi(campaign)),
      );
      navigator.canPop() ? navigator.pushReplacement(route) : navigator.push(route);
    } else if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: AppColors.green.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 48, color: AppColors.green),
              ),
              const SizedBox(height: 20),
              const Text('Campagne radio créée !', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                '« ${campaign.name} » sur ${draft.station} : $broadcastCount diffusion${broadcastCount > 1 ? 's' : ''} '
                'planifiée${broadcastCount > 1 ? 's' : ''} à partir du ${_fmtDay(draft.startDate)}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.gray500, height: 1.45),
              ),
              const SizedBox(height: 8),
              const Text(
                'Elle est en brouillon : validez-la depuis son détail quand tout est prêt.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppColors.gray400),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  onPressed: () => _close(context, openCampaign: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: const Text('Voir la campagne', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _close(context, openCampaign: false),
                child: const Text('Terminer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
