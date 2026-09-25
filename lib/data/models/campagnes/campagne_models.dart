// ===========================================================
// TYPE DE CAMPAGNE
// ===========================================================

enum CampaignType { digital, radio, poster }

CampaignType campaignTypeFromJson(String value) => switch (value) {
      'DIGITAL' => CampaignType.digital,
      'RADIO' => CampaignType.radio,
      'POSTER' => CampaignType.poster,
      _ => throw FormatException('Type de campagne inconnu: $value'),
    };

String campaignTypeToJson(CampaignType type) => switch (type) {
      CampaignType.digital => 'DIGITAL',
      CampaignType.radio => 'RADIO',
      CampaignType.poster => 'POSTER',
    };

String campaignTypeLabel(CampaignType type) => switch (type) {
      CampaignType.digital => 'Campagne Digitale',
      CampaignType.radio => 'Campagne Radio',
      CampaignType.poster => 'Supports Publicitaires',
    };

// ===========================================================
// STATUT DE CAMPAGNE
// ===========================================================

enum CampaignStatus { draft, planned, inProgress, completed, cancelled }

CampaignStatus campaignStatusFromJson(String value) => switch (value) {
      'DRAFT' => CampaignStatus.draft,
      'PLANNED' => CampaignStatus.planned,
      'IN_PROGRESS' => CampaignStatus.inProgress,
      'COMPLETED' => CampaignStatus.completed,
      'CANCELLED' => CampaignStatus.cancelled,
      _ => throw FormatException('Statut de campagne inconnu: $value'),
    };

String campaignStatusToJson(CampaignStatus status) => switch (status) {
      CampaignStatus.draft => 'DRAFT',
      CampaignStatus.planned => 'PLANNED',
      CampaignStatus.inProgress => 'IN_PROGRESS',
      CampaignStatus.completed => 'COMPLETED',
      CampaignStatus.cancelled => 'CANCELLED',
    };

// Aligné volontairement sur les libellés déjà utilisés par les filtres de
// campagne.dart ('Active', 'Brouillon', 'Terminée') pour que le filtrage
// existant fonctionne sans y toucher (voir étape 10).
String campaignStatusLabel(CampaignStatus status) => switch (status) {
      CampaignStatus.draft => 'Brouillon',
      CampaignStatus.planned => 'Planifiée',
      CampaignStatus.inProgress => 'Active',
      CampaignStatus.completed => 'Terminée',
      CampaignStatus.cancelled => 'Annulée',
    };

// ===========================================================
// AUTEUR (launchedBy)
// ===========================================================

class LaunchedByModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  const LaunchedByModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory LaunchedByModel.fromJson(Map<String, dynamic> json) => LaunchedByModel(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
      );
}

// ===========================================================
// CAMPAGNE
// ===========================================================

class CampagneModel {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double plannedBudget;
  final double actualBudget;
  final CampaignStatus status;
  final String objective;
  final CampaignType type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LaunchedByModel launchedBy;

  const CampagneModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.plannedBudget,
    required this.actualBudget,
    required this.status,
    required this.objective,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.launchedBy,
  });

  factory CampagneModel.fromJson(Map<String, dynamic> json) => CampagneModel(
        id: json['id'] as String,
        name: json['name'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        // `plannedBudget`/`actualBudget` sont des `Decimal` Prisma : selon le
        // driver, sérialisés en string OU en number (doc API §4, avertissement
        // explicite). On passe systématiquement par `toString()` avant
        // `num.parse` pour couvrir les deux cas sans planter.
        plannedBudget: num.parse(json['plannedBudget'].toString()).toDouble(),
        actualBudget: num.parse(json['actualBudget'].toString()).toDouble(),
        status: campaignStatusFromJson(json['status'] as String),
        objective: json['objective'] as String,
        type: campaignTypeFromJson(json['type'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        launchedBy: LaunchedByModel.fromJson(json['launchedBy'] as Map<String, dynamic>),
      );
}

// ===========================================================
// REQUÊTE DE CRÉATION
// ===========================================================

class CreateCampagneRequest {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double plannedBudget;
  final String objective;
  final CampaignType type;

  const CreateCampagneRequest({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.plannedBudget,
    required this.objective,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        // Le backend valide avec @IsDateString() (ISO 8601). On envoie
        // systématiquement en UTC pour éviter qu'un décalage de fuseau
        // horaire ne fasse glisser d'un jour la date choisie par
        // l'utilisateur au moment du parsing côté serveur.
        'startDate': startDate.toUtc().toIso8601String(),
        'endDate': endDate.toUtc().toIso8601String(),
        // @IsNumber({ maxDecimalPlaces: 2 }) côté DTO : ne pas envoyer plus
        // de 2 décimales (le formulaire, étape 8, s'en charge déjà).
        'plannedBudget': plannedBudget,
        'objective': objective,
        'type': campaignTypeToJson(type),
      };
}

// ===========================================================
// PAGE PAGINÉE (format unique décrit doc API §20)
// ===========================================================

class CampagnesPage {
  final List<CampagneModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const CampagnesPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CampagnesPage.fromJson(Map<String, dynamic> json) => CampagnesPage(
        items: (json['items'] as List)
            .map((e) => CampagneModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        limit: json['limit'] as int,
        totalPages: json['totalPages'] as int,
      );
}