import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import '../../data/datasources/campagne_remote_datasource.dart';
import '../../data/repositories/campagne_repository.dart';
import '../../data/models/campagnes/campagne_models.dart';
import '../network/app_exceptions.dart';

final campagneRemoteDatasourceProvider = Provider(
  (ref) => CampagneRemoteDatasource(ref.read(apiClientProvider).dio),
);

final campagneRepositoryProvider = Provider(
  (ref) => CampagneRepository(ref.read(campagneRemoteDatasourceProvider)),
);

enum CampagnesStatus { initial, loading, loaded, error }

class CampagnesState {
  final CampagnesStatus status;
  final List<CampagneModel> items;
  final String? errorMessage;

  const CampagnesState({
    required this.status,
    this.items = const [],
    this.errorMessage,
  });
}

class CampagnesNotifier extends StateNotifier<CampagnesState> {
  final CampagneRepository _repository;

  CampagnesNotifier(this._repository) : super(const CampagnesState(status: CampagnesStatus.initial)) {
    load();
  }

  Future<void> load() async {
    state = const CampagnesState(status: CampagnesStatus.loading);
    try {
      // MVP : une seule page (limite 50), pas de pagination infinie pour
      // l'instant — voir "Ce qui n'est volontairement pas couvert".
      final page = await _repository.list(page: 1, limit: 50);
      state = CampagnesState(status: CampagnesStatus.loaded, items: page.items);
    } on AppException catch (e) {
      state = CampagnesState(status: CampagnesStatus.error, errorMessage: e.message);
    }
  }

  Future<void> refresh() => load();
}

final campagnesNotifierProvider = StateNotifierProvider<CampagnesNotifier, CampagnesState>(
  (ref) => CampagnesNotifier(ref.read(campagneRepositoryProvider)),
);