import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/data/models/campagnes/campaign_creation_models.dart';

void main() {
  test('every digital objective maps to a backend enum value', () {
    const backend = {'AWARENESS', 'ENGAGEMENT', 'TRAFFIC', 'MESSAGES', 'LEADS', 'CONVERSION', 'SALES'};
    expect(digitalObjectiveOptions.map((o) => o.code).toSet(), backend);
  });

  test('age ranges stay within the 13-65 bounds accepted by the backend', () {
    for (final (min, max) in ageRangeOptions.values) {
      expect(min, greaterThanOrEqualTo(13));
      expect(max, lessThanOrEqualTo(65));
      expect(min, lessThanOrEqualTo(max));
    }
  });

  test('genders map to ALL, MALE and FEMALE', () {
    expect(genderOptions.values.toSet(), {'ALL', 'MALE', 'FEMALE'});
  });

  test('splitList cleans comma or semicolon separated zones', () {
    expect(splitList(' Douala, Yaoundé ;Bafoussam,, '), ['Douala', 'Yaoundé', 'Bafoussam']);
    expect(splitList(''), isEmpty);
  });
}
