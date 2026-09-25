import '../datasources/simulation_remote_datasource.dart';
import '../models/simulation/simulation_models.dart';

class SimulationRepository {
  final SimulationRemoteDatasource _remote;
  SimulationRepository(this._remote);

  Future<List<SimulationQuestionModel>> getQuestions() => _remote.getQuestions();

  Future<SimulationModel> submit(String campaignId, SubmitSimulationRequest request) =>
      _remote.submit(campaignId, request);

  Future<List<SimulationModel>> getHistory(String campaignId) => _remote.getHistory(campaignId);
}