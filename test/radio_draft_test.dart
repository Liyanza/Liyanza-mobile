import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/data/models/campagnes/radio_draft.dart';

void main() {
  RadioDraft draft({required DateTime start, required DateTime end}) => RadioDraft(today: start)
    ..startDate = start
    ..endDate = end;

  test('parses the start of a slot', () {
    expect(parseSlotStart('07h00 - 09h00'), (7, 0));
    expect(parseSlotStart('19h30 - 22h00'), (19, 30));
    expect(parseSlotStart('matin'), isNull);
  });

  test('plans one broadcast per slot on each chosen weekday, in order', () {
    // Lundi 12 octobre 2026 → dimanche 18 octobre 2026.
    final d = draft(start: DateTime(2026, 10, 12), end: DateTime(2026, 10, 18))
      ..slots
          .replaceRange(0, 3, ['17h00 - 19h00', '07h00 - 09h00'])
      ..weekdays
          .removeWhere((day) => day > 3); // lundi, mardi, mercredi
    final schedule = buildRadioSchedule(d, now: DateTime(2026, 10, 1));

    expect(schedule.truncated, isFalse);
    expect(schedule.broadcasts, hasLength(6));
    expect(schedule.broadcasts.first.scheduledAt, DateTime(2026, 10, 12, 7));
    expect(schedule.broadcasts[1].scheduledAt, DateTime(2026, 10, 12, 17));
    expect(schedule.broadcasts.last.scheduledAt, DateTime(2026, 10, 14, 17));
    expect(schedule.broadcasts.every((b) => b.durationSeconds == 30), isTrue);
  });

  test('skips slots already past today', () {
    final d = draft(start: DateTime(2026, 10, 12), end: DateTime(2026, 10, 12))
      ..weekdays.addAll({1, 2, 3, 4, 5, 6, 7});
    final schedule = buildRadioSchedule(d, now: DateTime(2026, 10, 12, 10));
    // Créneaux par défaut 7 h, 12 h et 17 h : seul 7 h est passé.
    expect(schedule.broadcasts.map((b) => b.scheduledAt.hour), [12, 17]);
  });

  test('stops at the 500-broadcast ceiling of the API', () {
    final d = draft(start: DateTime(2026, 1, 1), end: DateTime(2026, 12, 31))
      ..weekdays.addAll({1, 2, 3, 4, 5, 6, 7})
      ..slots.addAll(['05h00 - 07h00', '09h00 - 12h00']);
    final schedule = buildRadioSchedule(d, now: DateTime(2025, 12, 31));
    expect(schedule.broadcasts, hasLength(maxBroadcasts));
    expect(schedule.truncated, isTrue);
  });

  test('objective text carries the station, zone and target', () {
    final d = RadioDraft()
      ..station = 'Sweet FM'
      ..objective = 'Promotion'
      ..zone = 'Douala'
      ..target = 'Étudiants';
    expect(d.objectiveText, 'Promotion · Diffusion radio — Sweet FM · zone Douala · cible : Étudiants');
  });
}
