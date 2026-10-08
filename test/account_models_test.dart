import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/data/models/account/account_models.dart';
import 'package:liyanza_mobile/data/models/auth/auth_models.dart';
import 'package:liyanza_mobile/features/notification/notification.dart';

void main() {
  test('profile builds initials from the name, else from the email', () {
    final named = ProfileModel.fromJson({
      'id': 'u1',
      'email': 'awa@kiyanza.com',
      'firstName': 'awa',
      'lastName': 'Ndiaye',
      'role': 'MARKETING_MANAGER',
      'companyId': 'c1',
      'createdAt': '2026-10-01T08:00:00.000Z',
    });
    expect(named.initials, 'AN');
    expect(named.fullName, 'awa Ndiaye');
    expect(userRoleLabel(named.role), 'Responsable marketing');

    final unnamed = ProfileModel.fromJson({
      'id': 'u2',
      'email': 'jean@kiyanza.com',
      'firstName': '',
      'lastName': '',
      'role': 'ADMIN',
      'createdAt': '2026-10-01T08:00:00.000Z',
    });
    expect(unnamed.initials, 'J');
    expect(unnamed.role, UserRole.admin);
  });

  test('notifications page maps read status and type', () {
    final page = NotificationsPage.fromJson({
      'items': [
        {'id': 'n1', 'title': 'Alerte', 'message': 'CPC élevé', 'type': 'WARNING', 'sentAt': '2026-10-08T09:00:00.000Z', 'readStatus': 'UNREAD'},
        {'id': 'n2', 'title': 'Info', 'message': '', 'type': 'INFO', 'sentAt': '2026-10-07T09:00:00.000Z', 'readStatus': 'READ'},
      ],
      'total': 2,
      'page': 1,
      'limit': 20,
      'totalPages': 1,
    });
    expect(page.items.first.isRead, isFalse);
    expect(page.items.first.kind, NotificationKind.warning);
    expect(page.items.first.markedRead().isRead, isTrue);
    expect(page.items.last.isRead, isTrue);
  });

  test('notifications are grouped by day', () {
    final now = DateTime(2026, 10, 8, 15);
    expect(notificationGroup(DateTime(2026, 10, 8, 9), now), "AUJOURD'HUI");
    expect(notificationGroup(DateTime(2026, 10, 7, 23), now), 'HIER');
    expect(notificationGroup(DateTime(2026, 10, 1), now), 'PLUS ANCIENNES');
  });

  test('relative time reads naturally', () {
    final now = DateTime(2026, 10, 8, 15, 0);
    expect(relativeTime(now.subtract(const Duration(seconds: 20)), now), "à l'instant");
    expect(relativeTime(now.subtract(const Duration(minutes: 5)), now), 'il y a 5 min');
    expect(relativeTime(now.subtract(const Duration(hours: 3)), now), 'il y a 3 h');
  });
}
