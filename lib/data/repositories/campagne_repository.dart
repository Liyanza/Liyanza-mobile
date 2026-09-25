import '../datasources/campagne_remote_datasource.dart';
import '../models/campagnes/campagne_models.dart';

class CampagneRepository {
  final CampagneRemoteDatasource _remote;

  CampagneRepository(this._remote);

  Future<CampagnesPage> list({
    int page = 1,
    int limit = 10,
    CampaignStatus? status,
    CampaignType? type,
  }) =>
      _remote.list(page: page, limit: limit, status: status, type: type);

  Future<CampagneModel> create(CreateCampagneRequest request) => _remote.create(request);

  Future<CampagneModel> getById(String id) => _remote.getById(id);
}