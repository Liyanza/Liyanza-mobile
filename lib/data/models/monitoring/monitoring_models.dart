import '../auth/auth_models.dart';

double? _toDoubleOrNull(Object? value) => value is num ? value.toDouble() : null;

// ===========================================================
// DIFFUSIONS RADIO (GET /campagnes/:id/planning)
// ===========================================================

enum BroadcastStatus { planned, broadcasted, missed, cancelled }

BroadcastStatus broadcastStatusFromJson(String? value) => switch (value) {
      'BROADCASTED' => BroadcastStatus.broadcasted,
      'MISSED' => BroadcastStatus.missed,
      'CANCELLED' => BroadcastStatus.cancelled,
      _ => BroadcastStatus.planned,
    };

class BroadcastModel {
  final String id;
  final DateTime scheduledAt;
  final DateTime? actualBroadcastAt;
  final int durationSeconds;
  final BroadcastStatus status;

  const BroadcastModel({
    required this.id,
    required this.scheduledAt,
    this.actualBroadcastAt,
    required this.durationSeconds,
    required this.status,
  });

  /// Prévue, heure passée, sans constat : à vérifier auprès de la radio.
  bool awaitingConstat(DateTime now) => status == BroadcastStatus.planned && scheduledAt.isBefore(now);

  factory BroadcastModel.fromJson(Map<String, dynamic> json) => BroadcastModel(
        id: json['id'] as String,
        scheduledAt: DateTime.parse(json['scheduledAt'] as String),
        actualBroadcastAt: json['actualBroadcastAt'] == null ? null : DateTime.parse(json['actualBroadcastAt'] as String),
        durationSeconds: (json['duration'] as num?)?.toInt() ?? 0,
        status: broadcastStatusFromJson(json['status'] as String?),
      );
}

// ===========================================================
// TERRAIN (GET /prestations)
// ===========================================================

enum ProofStatus { pending, validated, rejected }

ProofStatus proofStatusFromJson(String? value) => switch (value) {
      'VALIDATED' => ProofStatus.validated,
      'REJECTED' => ProofStatus.rejected,
      _ => ProofStatus.pending,
    };

String installationStatusLabel(String status) => switch (status) {
      'PLANNED' => 'Planifiée',
      'CREATED' => 'Créée',
      'IN_PROGRESS' => 'En cours',
      'INSTALLED' => 'Installée',
      'VALIDATED' => 'Validée',
      'REJECTED' => 'Refusée',
      _ => status,
    };

class ProofModel {
  final String photo;
  final DateTime takenAt;
  final ProofStatus status;
  final String? comment;

  const ProofModel({required this.photo, required this.takenAt, required this.status, this.comment});

  factory ProofModel.fromJson(Map<String, dynamic> json) => ProofModel(
        photo: json['photo'] as String,
        takenAt: DateTime.parse(json['takenAt'] as String),
        status: proofStatusFromJson(json['validationStatus'] as String?),
        comment: json['validationComment'] as String?,
      );
}

class InstallationModel {
  final String id;
  final String location;
  final String campaignName;
  final String status;
  final DateTime plannedDate;
  final ProofModel? proof;

  /// Écart entre l'emplacement prévu et la photo, en mètres.
  final double? distanceMeters;
  final bool? locationMatch;

  const InstallationModel({
    required this.id,
    required this.location,
    required this.campaignName,
    required this.status,
    required this.plannedDate,
    this.proof,
    this.distanceMeters,
    this.locationMatch,
  });

  factory InstallationModel.fromJson(Map<String, dynamic> json) => InstallationModel(
        id: json['id'] as String,
        location: json['location'] as String? ?? '',
        campaignName: json['campaignName'] as String? ?? '',
        status: json['status'] as String? ?? '',
        plannedDate: DateTime.parse(json['plannedInstallationDate'] as String),
        proof: json['proof'] is Map ? ProofModel.fromJson(json['proof'] as Map<String, dynamic>) : null,
        distanceMeters: _toDoubleOrNull(json['distanceMeters']),
        locationMatch: json['locationMatch'] as bool?,
      );
}

// ===========================================================
// TÂCHES (GET /tasks, PATCH /tasks/:id/statut)
// ===========================================================

enum TaskStatus { todo, inProgress, done, late }

TaskStatus taskStatusFromJson(String? value) => switch (value) {
      'IN_PROGRESS' => TaskStatus.inProgress,
      'DONE' => TaskStatus.done,
      'LATE' => TaskStatus.late,
      _ => TaskStatus.todo,
    };

String taskStatusToJson(TaskStatus status) => switch (status) {
      TaskStatus.todo => 'TODO',
      TaskStatus.inProgress => 'IN_PROGRESS',
      TaskStatus.done => 'DONE',
      TaskStatus.late => 'LATE',
    };

String taskStatusLabel(TaskStatus status) => switch (status) {
      TaskStatus.todo => 'À faire',
      TaskStatus.inProgress => 'En cours',
      TaskStatus.done => 'Terminée',
      TaskStatus.late => 'En retard',
    };

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime? dueDate;
  final List<String> assignees;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.dueDate,
    this.assignees = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        status: taskStatusFromJson(json['status'] as String?),
        dueDate: json['dueDate'] == null ? null : DateTime.parse(json['dueDate'] as String),
        assignees: (json['assignees'] as List? ?? const []).map((a) {
          final user = (a as Map<String, dynamic>)['user'] as Map<String, dynamic>? ?? const {};
          final name = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
          return name.isNotEmpty ? name : (user['email'] as String? ?? '');
        }).where((n) => n.isNotEmpty).toList(),
      );
}

// ===========================================================
// ÉQUIPE (GET /users, administrateur)
// ===========================================================

class MemberModel {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final bool active;

  const MemberModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.active,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    final name = '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim();
    return MemberModel(
      id: json['id'] as String,
      fullName: name.isNotEmpty ? name : json['email'] as String,
      email: json['email'] as String,
      role: userRoleFromJson(json['role'] as String),
      active: json['deactivatedAt'] == null,
    );
  }
}

/// Réponse paginée `{items}` ou liste brute, selon la route.
List<Map<String, dynamic>> itemsOf(Object? data) {
  final raw = data is Map ? data['items'] : data;
  return (raw as List? ?? const []).cast<Map<String, dynamic>>();
}
