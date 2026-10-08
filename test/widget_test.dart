import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:liyanza_mobile/core/providers/auth_providers.dart';
import 'package:liyanza_mobile/core/storage/secure_token_storage.dart';
import 'package:liyanza_mobile/main.dart';

/// Stockage sans session (pas de plugin natif en test).
class _EmptyTokenStorage extends SecureTokenStorage {
  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;
}

void main() {
  testWidgets('splash shows the welcome, then sends a signed-out user to onboarding', (tester) async {
    // Petit téléphone : l'écran de démarrage ne doit pas déborder.
    tester.view.physicalSize = const Size(360 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [secureTokenStorageProvider.overrideWithValue(_EmptyTokenStorage())],
        child: const KiyanzaApp(),
      ),
    );

    expect(find.textContaining('Bienvenue sur', findRichText: true), findsOneWidget);
    expect(find.text('Découvrir'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Votre copilote marketing'), findsOneWidget);
  });
}
