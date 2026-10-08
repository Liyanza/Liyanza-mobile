import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../campagnes/campagne_detail.dart';
import '../core/network/app_exceptions.dart';
import '../core/providers/auth_providers.dart';
import '../core/providers/campagne_providers.dart';
import '../core/providers/campaign_detail_providers.dart';
import '../core/providers/dashboard_providers.dart';
import '../core/theme/kiyanza_colors.dart';
import '../data/datasources/monitoring_remote_datasource.dart';
import '../data/models/account/account_models.dart';
import '../data/models/auth/auth_models.dart';
import '../data/models/campagnes/campagne_models.dart';
import '../data/models/campagnes/campaign_detail_models.dart';
import '../data/models/monitoring/monitoring_models.dart';

final monitoringRemoteDatasourceProvider = Provider(
  (ref) => MonitoringRemoteDatasource(ref.read(apiClientProvider).dio),
);

String _two(int v) => v.toString().padLeft(2, '0');
String _time(DateTime d) => '${_two(d.toLocal().hour)}h${_two(d.toLocal().minute)}';

void _snack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

String _errorText(Object error) => error is AppException ? error.message : 'Une erreur est survenue.';

/// Suivi opérationnel des campagnes : diffusions radio, terrain, tâches et
/// équipe (mêmes données que le site).
class MonitoringScreen extends ConsumerWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(meProvider).valueOrNull;
    final isAdmin = me?.role == UserRole.admin;
    final canManage = me != null && canSeeRecommendations(me.role);
    final tabs = <(String, Widget)>[
      ('Radio', _RadioTab(canManage: canManage)),
      ('Terrain', _FieldTab(canManage: canManage)),
      ('Tâches', const _TasksTab()),
      if (isAdmin) ('Équipe', const _TeamTab()),
    ];

    return DefaultTabController(
      key: ValueKey(tabs.length),
      length: tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Monitoring', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          bottom: TabBar(
            isScrollable: tabs.length > 3,
            labelColor: AppColors.black,
            unselectedLabelColor: AppColors.gray400,
            indicatorColor: AppColors.green,
            tabs: [for (final tab in tabs) Tab(text: tab.$1)],
          ),
        ),
        body: TabBarView(children: [for (final tab in tabs) tab.$2]),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Empty(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 40),
        Icon(icon, size: 38, color: AppColors.gray400),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray500, height: 1.4)),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;

  const _Chip(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// =============================================================
// RADIO
// =============================================================

class _RadioTab extends ConsumerStatefulWidget {
  final bool canManage;

  const _RadioTab({required this.canManage});

  @override
  ConsumerState<_RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends ConsumerState<_RadioTab> {
  String? _campaignId;
  ConformityReportModel? _report;
  List<BroadcastModel> _broadcasts = const [];
  bool _loading = false;
  String? _error;

  Future<void> _load(String campaignId) async {
    setState(() {
      _campaignId = campaignId;
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<Object>([
        ref.read(monitoringRemoteDatasourceProvider).broadcasts(campaignId),
        if (widget.canManage) ref.read(campaignDetailRemoteDatasourceProvider).conformityReport(campaignId),
      ]);
      if (!mounted || _campaignId != campaignId) return;
      setState(() {
        _broadcasts = results[0] as List<BroadcastModel>;
        _report = results.length > 1 ? results[1] as ConformityReportModel : null;
      });
    } catch (e) {
      if (mounted) setState(() => _error = _errorText(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _record(BroadcastModel broadcast) async {
    final choice = await showModalBottomSheet<DateTime>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Diffusion prévue le ${formatDay(broadcast.scheduledAt)} à ${_time(broadcast.scheduledAt)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: AppColors.green),
              title: const Text("Diffusée à l'heure prévue"),
              onTap: () => Navigator.pop(sheetContext, broadcast.scheduledAt),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Diffusée à une autre heure…'),
              onTap: () async {
                final picked = await showTimePicker(
                  context: sheetContext,
                  initialTime: TimeOfDay.fromDateTime(broadcast.scheduledAt.toLocal()),
                );
                if (picked == null || !sheetContext.mounted) return;
                final d = broadcast.scheduledAt.toLocal();
                Navigator.pop(sheetContext, DateTime(d.year, d.month, d.day, picked.hour, picked.minute));
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                "Sans constat, une diffusion passée compte comme manquée dans le rapport de conformité.",
                style: TextStyle(fontSize: 11.5, color: AppColors.gray500),
              ),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    try {
      await ref.read(monitoringRemoteDatasourceProvider).recordBroadcast(broadcast.id, choice);
      if (!mounted) return;
      _snack(context, 'Diffusion constatée.');
      await _load(_campaignId!);
    } catch (e) {
      if (mounted) _snack(context, _errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final campaignsState = ref.watch(campagnesNotifierProvider);
    if (campaignsState.status == CampagnesStatus.loading || campaignsState.status == CampagnesStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    final campaigns = campaignsState.items
        .where((c) => c.type == CampaignType.radio && c.status != CampaignStatus.cancelled)
        .toList();
    if (campaigns.isEmpty) {
      return const _Empty(Icons.radio_outlined, 'Aucune campagne radio. Créez-en une avec le bouton + pour suivre ses diffusions ici.');
    }
    if (_campaignId == null || !campaigns.any((c) => c.id == _campaignId)) {
      final running = campaigns.where((c) => c.status == CampaignStatus.inProgress);
      final first = running.isNotEmpty ? running.first : campaigns.first;
      _campaignId = first.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _load(first.id);
      });
    }

    final now = DateTime.now();
    final report = _report;
    return RefreshIndicator(
      onRefresh: () => _load(_campaignId!),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _campaignId,
            isExpanded: true,
            onChanged: _loading ? null : (id) => id == null ? null : _load(id),
            items: [
              for (final c in campaigns)
                DropdownMenuItem(value: c.id, child: Text(c.name, overflow: TextOverflow.ellipsis)),
            ],
            decoration: InputDecoration(
              labelText: 'Campagne radio',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Text(_error!, style: const TextStyle(color: Color(0xFFDC2626)))
          else ...[
            if (report != null)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Figure('${report.total}', 'Prévues'),
                    _Figure('${report.broadcasted}', 'Diffusées', const Color(0xFF16A34A)),
                    _Figure('${report.missed}', 'Manquées', report.missed > 0 ? const Color(0xFFDC2626) : null),
                    _Figure(report.rate == null ? '—' : formatPercent(report.rate!), 'Conformité'),
                  ],
                ),
              ),
            if (_broadcasts.isEmpty)
              const Text('Aucune diffusion planifiée.', style: TextStyle(color: AppColors.gray500))
            else
              for (final b in _broadcasts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    switch (b.status) {
                      BroadcastStatus.broadcasted => Icons.check_circle,
                      BroadcastStatus.cancelled => Icons.block,
                      _ => b.awaitingConstat(now) ? Icons.error_outline : Icons.schedule,
                    },
                    color: switch (b.status) {
                      BroadcastStatus.broadcasted => const Color(0xFF16A34A),
                      BroadcastStatus.cancelled => AppColors.gray400,
                      _ => b.awaitingConstat(now) ? const Color(0xFFEA580C) : AppColors.blue,
                    },
                  ),
                  title: Text('${formatDay(b.scheduledAt)} · ${_time(b.scheduledAt)}',
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    switch (b.status) {
                      BroadcastStatus.broadcasted => 'Diffusée à ${_time(b.actualBroadcastAt ?? b.scheduledAt)}',
                      BroadcastStatus.cancelled => 'Annulée',
                      BroadcastStatus.missed => 'Manquée',
                      BroadcastStatus.planned => b.awaitingConstat(now) ? 'À vérifier auprès de la radio' : 'À venir · ${b.durationSeconds} s',
                    },
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: widget.canManage && b.awaitingConstat(now)
                      ? TextButton(onPressed: () => _record(b), child: const Text('Constater'))
                      : null,
                ),
            if (_broadcasts.length == 100)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Les 100 premières diffusions sont affichées.', style: TextStyle(fontSize: 11.5, color: AppColors.gray400)),
              ),
          ],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;

  const _Figure(this.value, this.label, [this.color]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: color ?? AppColors.black)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
      ],
    );
  }
}

// =============================================================
// TERRAIN
// =============================================================

class _FieldTab extends ConsumerStatefulWidget {
  final bool canManage;

  const _FieldTab({required this.canManage});

  @override
  ConsumerState<_FieldTab> createState() => _FieldTabState();
}

class _FieldTabState extends ConsumerState<_FieldTab> {
  late Future<List<InstallationModel>> _future = _fetch();

  Future<List<InstallationModel>> _fetch() => ref.read(monitoringRemoteDatasourceProvider).installations();

  Future<void> _refresh() async {
    final future = _fetch();
    setState(() => _future = future);
    await future;
  }

  Future<void> _open(InstallationModel item) async {
    final proof = item.proof;
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _InstallationSheet(item: item, canReview: widget.canManage && proof?.status == ProofStatus.pending),
    );
    if (changed == true) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InstallationModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return _Empty(Icons.cloud_off_outlined, _errorText(snapshot.error!));
        final items = snapshot.data!;
        if (items.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: const _Empty(Icons.place_outlined, 'Aucun emplacement suivi. Les poses d’affiches et de supports apparaîtront ici avec leurs preuves photo.'),
          );
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final proof = item.proof;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _open(item),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: proof == null
                              ? Container(color: AppColors.gray100, child: const Icon(Icons.photo_camera_outlined, color: AppColors.gray400))
                              : Image.network(proof.photo, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.gray100, child: const Icon(Icons.broken_image_outlined))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.location, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                            const SizedBox(height: 2),
                            Text('${item.campaignName} · prévue le ${formatDay(item.plannedDate)}',
                                style: const TextStyle(fontSize: 11.5, color: AppColors.gray500)),
                            const SizedBox(height: 6),
                            Wrap(spacing: 6, runSpacing: 4, children: [
                              _Chip(installationStatusLabel(item.status), AppColors.blue),
                              if (proof == null)
                                const _Chip('Sans preuve', AppColors.gray500)
                              else
                                switch (proof.status) {
                                  ProofStatus.validated => const _Chip('Preuve validée', Color(0xFF16A34A)),
                                  ProofStatus.rejected => const _Chip('Preuve refusée', Color(0xFFDC2626)),
                                  ProofStatus.pending => const _Chip('Preuve à valider', Color(0xFFEA580C)),
                                },
                              if (item.locationMatch == false) const _Chip('Lieu à vérifier', Color(0xFFDC2626)),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _InstallationSheet extends ConsumerStatefulWidget {
  final InstallationModel item;
  final bool canReview;

  const _InstallationSheet({required this.item, required this.canReview});

  @override
  ConsumerState<_InstallationSheet> createState() => _InstallationSheetState();
}

class _InstallationSheetState extends ConsumerState<_InstallationSheet> {
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _review(bool validate) async {
    setState(() => _busy = true);
    try {
      await ref.read(monitoringRemoteDatasourceProvider).reviewProof(widget.item.id, validate: validate, comment: _comment.text);
      if (!mounted) return;
      _snack(context, validate ? 'Preuve validée.' : 'Preuve refusée.');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _snack(context, _errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final proof = item.proof;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16 + MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(item.location, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('${item.campaignName} · prévue le ${formatDay(item.plannedDate)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
              const SizedBox(height: 12),
              if (proof == null)
                const Text('Aucune preuve photo envoyée pour le moment.', style: TextStyle(color: AppColors.gray500))
              else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: InteractiveViewer(
                      child: Image.network(proof.photo, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.gray100, child: const Icon(Icons.broken_image_outlined))),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Photo prise le ${formatDay(proof.takenAt)} à ${_time(proof.takenAt)}'
                  '${item.distanceMeters != null ? ' · à ${item.distanceMeters!.round()} m de l’emplacement prévu' : ''}',
                  style: const TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
                if (proof.comment != null && proof.comment!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Commentaire : ${proof.comment}', style: const TextStyle(fontSize: 12, color: AppColors.gray600)),
                ],
                if (widget.canReview) ...[
                  const SizedBox(height: 14),
                  TextField(
                    controller: _comment,
                    maxLength: 1000,
                    decoration: const InputDecoration(labelText: 'Commentaire (facultatif)', border: OutlineInputBorder()),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy ? null : () => _review(false),
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                          child: const Text('Refuser'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _busy ? null : () => _review(true),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green, foregroundColor: AppColors.white, elevation: 0),
                          child: const Text('Valider'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// TÂCHES
// =============================================================

class _TasksTab extends ConsumerStatefulWidget {
  const _TasksTab();

  @override
  ConsumerState<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<_TasksTab> {
  late Future<List<TaskModel>> _future = _fetch();

  Future<List<TaskModel>> _fetch() => ref.read(monitoringRemoteDatasourceProvider).tasks();

  Future<void> _refresh() async {
    final future = _fetch();
    setState(() => _future = future);
    await future;
  }

  Future<void> _setStatus(TaskModel task, TaskStatus status) async {
    try {
      await ref.read(monitoringRemoteDatasourceProvider).setTaskStatus(task.id, status);
      await _refresh();
    } catch (e) {
      if (mounted) _snack(context, _errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return _Empty(Icons.cloud_off_outlined, _errorText(snapshot.error!));
        final tasks = snapshot.data!;
        if (tasks.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: const _Empty(Icons.task_alt, 'Aucune tâche. Les tâches de l’équipe se créent sur kiyanza.com.'),
          );
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final color = switch (task.status) {
                TaskStatus.done => const Color(0xFF16A34A),
                TaskStatus.late => const Color(0xFFDC2626),
                TaskStatus.inProgress => AppColors.blue,
                TaskStatus.todo => AppColors.gray500,
              };
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                subtitle: Text(
                  [
                    if (task.assignees.isNotEmpty) task.assignees.join(', '),
                    if (task.dueDate != null) 'échéance ${formatDay(task.dueDate!)}',
                  ].join(' · '),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: PopupMenuButton<TaskStatus>(
                  tooltip: 'Changer le statut',
                  onSelected: (status) => _setStatus(task, status),
                  itemBuilder: (_) => [
                    for (final status in TaskStatus.values)
                      if (status != task.status) PopupMenuItem(value: status, child: Text(taskStatusLabel(status))),
                  ],
                  child: _Chip(taskStatusLabel(task.status), color),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// =============================================================
// ÉQUIPE (administrateur)
// =============================================================

class _TeamTab extends ConsumerWidget {
  const _TeamTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<MemberModel>>(
      future: ref.read(monitoringRemoteDatasourceProvider).members(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return _Empty(Icons.cloud_off_outlined, _errorText(snapshot.error!));
        final members = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            for (final m in members)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.green.withValues(alpha: 0.15),
                  child: Text(m.fullName[0].toUpperCase(), style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w700)),
                ),
                title: Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                subtitle: Text('${userRoleLabel(m.role)} · ${m.email}', style: const TextStyle(fontSize: 12)),
                trailing: m.active ? null : const _Chip('Désactivé', AppColors.gray500),
              ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Invitez et gérez les membres depuis kiyanza.com (Équipes).',
                  style: TextStyle(fontSize: 11.5, color: AppColors.gray400)),
            ),
          ],
        );
      },
    );
  }
}
