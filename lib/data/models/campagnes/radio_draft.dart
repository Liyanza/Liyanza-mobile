/// Campagne radio en cours de saisie : remplie écran par écran, puis
/// envoyée à l'API (campagne, canal radio, planning des diffusions), comme
/// l'assistant du site.
class RadioDraft {
  String station = '';
  String stationCoverage = '';
  String name = '';
  String objective = 'Notoriété';
  int budget = 100000;
  DateTime startDate;
  DateTime endDate;
  String zone = 'Nationale';
  String target = '';
  String spotName = '';
  int spotSeconds = 30;
  final List<String> slots = ['07h00 - 09h00', '12h00 - 14h00', '17h00 - 19h00'];

  /// 1 = lundi … 7 = dimanche (DateTime.weekday).
  final Set<int> weekdays = {1, 2, 3, 4, 5};

  RadioDraft({DateTime? today})
      : startDate = _day(today ?? DateTime.now()),
        endDate = _day(today ?? DateTime.now()).add(const Duration(days: 29));

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Objectif enregistré sur la campagne (la station n'a pas de champ dédié).
  String get objectiveText {
    final parts = [
      objective,
      'Diffusion radio — $station',
      if (zone.isNotEmpty) 'zone $zone',
      if (target.trim().isNotEmpty) 'cible : ${target.trim()}',
    ];
    return parts.join(' · ');
  }
}

/// Créneaux proposés (heure de début = heure de diffusion).
const radioSlotOptions = [
  '05h00 - 07h00',
  '07h00 - 09h00',
  '09h00 - 12h00',
  '12h00 - 14h00',
  '14h00 - 17h00',
  '17h00 - 19h00',
  '19h00 - 22h00',
];

const radioWeekdayLabels = {1: 'Lun', 2: 'Mar', 3: 'Mer', 4: 'Jeu', 5: 'Ven', 6: 'Sam', 7: 'Dim'};

/// Plafond de `POST /campagnes/:id/planning` (ArrayMaxSize côté backend).
const maxBroadcasts = 500;

class PlannedBroadcast {
  final DateTime scheduledAt;
  final int durationSeconds;

  const PlannedBroadcast(this.scheduledAt, this.durationSeconds);
}

class RadioSchedule {
  final List<PlannedBroadcast> broadcasts;

  /// Vrai si le plan dépassait le plafond et a été coupé.
  final bool truncated;

  const RadioSchedule(this.broadcasts, this.truncated);
}

/// « 07h00 - 09h00 » → (7, 0).
(int, int)? parseSlotStart(String slot) {
  final match = RegExp(r'^(\d{1,2})h(\d{2})').firstMatch(slot.trim());
  if (match == null) return null;
  return (int.parse(match.group(1)!), int.parse(match.group(2)!));
}

/// Diffusions concrètes : chaque jour retenu de la période, à l'heure de
/// début de chaque créneau, dans l'ordre chronologique. Les créneaux déjà
/// passés (le jour même) sont ignorés : ils compteraient comme manqués.
RadioSchedule buildRadioSchedule(RadioDraft draft, {DateTime? now}) {
  final cutoff = now ?? DateTime.now();
  final starts = draft.slots.map(parseSlotStart).whereType<(int, int)>().toList()
    ..sort((a, b) => (a.$1 * 60 + a.$2).compareTo(b.$1 * 60 + b.$2));
  final broadcasts = <PlannedBroadcast>[];
  var day = DateTime(draft.startDate.year, draft.startDate.month, draft.startDate.day);
  final last = DateTime(draft.endDate.year, draft.endDate.month, draft.endDate.day);
  while (!day.isAfter(last)) {
    if (draft.weekdays.contains(day.weekday)) {
      for (final (hours, minutes) in starts) {
        final at = DateTime(day.year, day.month, day.day, hours, minutes);
        if (!at.isAfter(cutoff)) continue;
        if (broadcasts.length >= maxBroadcasts) return RadioSchedule(broadcasts, true);
        broadcasts.add(PlannedBroadcast(at, draft.spotSeconds));
      }
    }
    day = DateTime(day.year, day.month, day.day + 1);
  }
  return RadioSchedule(broadcasts, false);
}
