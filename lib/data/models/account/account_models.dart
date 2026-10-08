import '../auth/auth_models.dart';

String userRoleLabel(UserRole role) => switch (role) {
      UserRole.admin => 'Administrateur',
      UserRole.marketingManager => 'Responsable marketing',
      UserRole.communityManager => 'Community manager',
      UserRole.provider => 'Prestataire terrain',
    };

// ===========================================================
// PROFIL (GET /users/me)
// ===========================================================

class ProfileModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final String? companyId;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    this.companyId,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  /// « Awa Ndiaye » → « AN ».
  String get initials {
    final letters = [firstName, lastName]
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim()[0].toUpperCase())
        .join();
    return letters.isNotEmpty ? letters : email[0].toUpperCase();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        phone: json['phone'] as String?,
        role: userRoleFromJson(json['role'] as String),
        companyId: json['companyId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// ===========================================================
// ENTREPRISE (GET / PATCH /entreprises/:id)
// ===========================================================

class CompanyModel {
  final String id;
  final String name;
  final String businessSector;
  final String address;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.businessSector,
    required this.address,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] as String,
        name: json['name'] as String,
        businessSector: json['businessSector'] as String? ?? '',
        address: json['address'] as String? ?? '',
      );
}

// ===========================================================
// NOTIFICATIONS (GET /notifications, PATCH /notifications/:id/lue)
// ===========================================================

enum NotificationKind { info, success, warning, error }

NotificationKind notificationKindFromJson(String? value) => switch (value) {
      'SUCCESS' => NotificationKind.success,
      'WARNING' => NotificationKind.warning,
      'ERROR' => NotificationKind.error,
      _ => NotificationKind.info,
    };

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationKind kind;
  final DateTime sentAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.kind,
    required this.sentAt,
    required this.isRead,
  });

  NotificationModel markedRead() => NotificationModel(
        id: id,
        title: title,
        message: message,
        kind: kind,
        sentAt: sentAt,
        isRead: true,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String? ?? '',
        kind: notificationKindFromJson(json['type'] as String?),
        sentAt: DateTime.parse(json['sentAt'] as String),
        isRead: json['readStatus'] == 'READ',
      );
}

class NotificationsPage {
  final List<NotificationModel> items;
  final int total;
  final int page;
  final int totalPages;

  const NotificationsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory NotificationsPage.fromJson(Map<String, dynamic> json) => NotificationsPage(
        items: (json['items'] as List? ?? const [])
            .map((n) => NotificationModel.fromJson(n as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num?)?.toInt() ?? 0,
        page: (json['page'] as num?)?.toInt() ?? 1,
        totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      );
}

/// Regroupement par jour : « AUJOURD'HUI », « HIER », sinon « PLUS ANCIENNES ».
String notificationGroup(DateTime sentAt, DateTime now) {
  final day = DateTime(sentAt.toLocal().year, sentAt.toLocal().month, sentAt.toLocal().day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  if (diff <= 0) return "AUJOURD'HUI";
  if (diff == 1) return 'HIER';
  return 'PLUS ANCIENNES';
}
