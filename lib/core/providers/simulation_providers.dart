import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import '../../data/datasources/simulation_remote_datasource.dart';
import '../../data/repositories/simulation_repository.dart';

final simulationRemoteDatasourceProvider = Provider(
  (ref) => SimulationRemoteDatasource(ref.read(apiClientProvider).dio),
);

final simulationRepositoryProvider = Provider(
  (ref) => SimulationRepository(ref.read(simulationRemoteDatasourceProvider)),
);