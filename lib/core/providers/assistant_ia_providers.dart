import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import '../../data/datasources/assistant_ia_remote_datasource.dart';
import '../../data/repositories/assistant_ia_repository.dart';

final assistantIaRemoteDatasourceProvider = Provider(
  (ref) => AssistantIaRemoteDatasource(ref.read(apiClientProvider).dio),
);

final assistantIaRepositoryProvider = Provider(
  (ref) => AssistantIaRepository(ref.read(assistantIaRemoteDatasourceProvider)),
);