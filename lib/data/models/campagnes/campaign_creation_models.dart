import 'package:flutter/material.dart';

/// Nom de la route du choix du type de campagne : la fin du parcours de
/// création y revient pour le refermer d'un coup.
const campaignTypeRouteName = 'campaign-type';

// ===========================================================
// OBJECTIFS DIGITAUX (enum DigitalObjective du backend)
// ===========================================================

class DigitalObjectiveOption {
  final String code;
  final String title;
  final String description;
  final IconData icon;

  const DigitalObjectiveOption(this.code, this.title, this.description, this.icon);
}

const digitalObjectiveOptions = [
  DigitalObjectiveOption('AWARENESS', 'Notoriété', 'Faire connaître ma marque au plus grand nombre', Icons.campaign_outlined),
  DigitalObjectiveOption('ENGAGEMENT', 'Engagement', "Susciter des réactions, commentaires et partages", Icons.favorite_border),
  DigitalObjectiveOption('TRAFFIC', 'Trafic', 'Envoyer des visiteurs vers mon site ou ma page', Icons.ads_click),
  DigitalObjectiveOption('MESSAGES', 'Conversations WhatsApp', 'Recevoir des messages de clients sur WhatsApp ou Messenger', Icons.chat_outlined),
  DigitalObjectiveOption('LEADS', 'Prospects', 'Collecter les coordonnées de clients potentiels', Icons.person_add_alt_outlined),
  DigitalObjectiveOption('CONVERSION', 'Conversions', 'Inciter à une action précise (inscription, réservation…)', Icons.call_made),
  DigitalObjectiveOption('SALES', 'Ventes', 'Vendre mes produits ou services', Icons.shopping_cart_outlined),
];

// ===========================================================
// AUDIENCE
// ===========================================================

class AudienceSelection {
  final int ageMin;
  final int ageMax;

  /// ALL, MALE ou FEMALE.
  final String gender;
  final List<String> locations;
  final List<String> interests;

  const AudienceSelection({
    required this.ageMin,
    required this.ageMax,
    required this.gender,
    required this.locations,
    required this.interests,
  });
}

/// Tranches proposées à l'écran ; bornes acceptées par le backend : 13 à 65.
const ageRangeOptions = <String, (int, int)>{
  '13 - 17 ans': (13, 17),
  '18 - 24 ans': (18, 24),
  '18 - 35 ans': (18, 35),
  '25 - 45 ans': (25, 45),
  '36 - 50 ans': (36, 50),
  '51 ans et +': (51, 65),
  'Tous âges (18 - 65 ans)': (18, 65),
};

const genderOptions = <String, String>{
  'Tous': 'ALL',
  'Femmes': 'FEMALE',
  'Hommes': 'MALE',
};

/// « Douala, Yaoundé ;Bafoussam » → [Douala, Yaoundé, Bafoussam].
List<String> splitList(String value) => value
    .split(RegExp(r'[,;]'))
    .map((part) => part.trim())
    .where((part) => part.isNotEmpty)
    .toList();
