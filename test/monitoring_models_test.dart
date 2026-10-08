import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/data/models/auth/auth_models.dart';
import 'package:liyanza_mobile/data/models/monitoring/monitoring_models.dart';

void main() {
  test('a past planned broadcast awaits a constat, a future one does not', () {
    final now = DateTime.utc(2026, 10, 8, 12);
    final past = BroadcastModel.fromJson({
      'id': 'b1',
      'scheduledAt': '2026-10-08T07:00:00.000Z',
      'actualBroadcastAt': null,
      'duration': 30,
      'status': 'PLANNED',
    });
    final future = BroadcastModel.fromJson({
      'id': 'b2',
      'scheduledAt': '2026-10-08T17:00:00.000Z',
      'duration': 30,
      'status': 'PLANNED',
    });
    final done = BroadcastModel.fromJson({
      'id': 'b3',
      'scheduledAt': '2026-10-07T07:00:00.000Z',
      'actualBroadcastAt': '2026-10-07T07:02:00.000Z',
      'duration': 30,
      'status': 'BROADCASTED',
    });
    expect(past.awaitingConstat(now), isTrue);
    expect(future.awaitingConstat(now), isFalse);
    expect(done.awaitingConstat(now), isFalse);
    expect(done.actualBroadcastAt, DateTime.utc(2026, 10, 7, 7, 2));
  });

  test('installations read their proof and location check', () {
    final item = InstallationModel.fromJson({
      'id': 'i1',
      'location': 'Carrefour Ndokoti',
      'campaignId': 'k1',
      'campaignName': 'Promo rentrée',
      'status': 'INSTALLED',
      'plannedInstallationDate': '2026-10-05T00:00:00.000Z',
      'proof': {
        'photo': 'https://cdn.example.com/p.jpg',
        'latitude': 4.05,
        'longitude': 9.76,
        'takenAt': '2026-10-05T09:00:00.000Z',
        'validationStatus': 'PENDING',
        'validationComment': null,
      },
      'distanceMeters': 412.6,
      'locationMatch': false,
    });
    expect(item.proof!.status, ProofStatus.pending);
    expect(item.distanceMeters, 412.6);
    expect(item.locationMatch, isFalse);
    expect(installationStatusLabel(item.status), 'Installée');

    final bare = InstallationModel.fromJson({
      'id': 'i2',
      'location': 'Akwa',
      'campaignName': 'X',
      'status': 'PLANNED',
      'plannedInstallationDate': '2026-10-06T00:00:00.000Z',
      'proof': null,
      'distanceMeters': null,
      'locationMatch': null,
    });
    expect(bare.proof, isNull);
  });

  test('tasks list assignee names and map statuses both ways', () {
    final task = TaskModel.fromJson({
      'id': 't1',
      'title': 'Vérifier les affiches',
      'status': 'IN_PROGRESS',
      'dueDate': '2026-10-10T00:00:00.000Z',
      'assignees': [
        {'user': {'firstName': 'Awa', 'lastName': 'Ndiaye', 'email': 'a@k.com'}},
        {'user': {'firstName': '', 'lastName': '', 'email': 'b@k.com'}},
      ],
    });
    expect(task.status, TaskStatus.inProgress);
    expect(task.assignees, ['Awa Ndiaye', 'b@k.com']);
    for (final status in TaskStatus.values) {
      expect(taskStatusFromJson(taskStatusToJson(status)), status);
    }
  });

  test('members accept a raw list and fall back to the email', () {
    final members = itemsOf([
      {'id': 'u1', 'email': 'awa@k.com', 'firstName': 'Awa', 'lastName': 'N', 'role': 'ADMIN', 'deactivatedAt': null},
      {'id': 'u2', 'email': 'x@k.com', 'firstName': '', 'lastName': '', 'role': 'PROVIDER', 'deactivatedAt': '2026-10-01T00:00:00.000Z'},
    ]).map(MemberModel.fromJson).toList();
    expect(members.first.role, UserRole.admin);
    expect(members.last.fullName, 'x@k.com');
    expect(members.last.active, isFalse);
    expect(itemsOf({'items': [], 'total': 0}), isEmpty);
  });
}
