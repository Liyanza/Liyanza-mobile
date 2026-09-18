import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/main.dart';

void main() {
  testWidgets('app loads splash screen and onboarding CTA', (tester) async {
    await tester.pumpWidget(const KiyanzaApp());

    expect(find.text('Bienvenue sur'), findsOneWidget);
    expect(find.text('Kiyanza'), findsOneWidget);
    expect(find.text('Découvrir'), findsOneWidget);
  });
}
