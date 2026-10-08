import 'package:dio/dio.dart';
import '../models/account/account_models.dart';
import '../../core/network/dio_error_mapper.dart';

/// Profil, entreprise et notifications de l'utilisateur connecté.
class AccountRemoteDatasource {
  final Dio _dio;

  AccountRemoteDatasource(this._dio);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<ProfileModel> profile() => _guard(() async {
        final response = await _dio.get('/users/me');
        return ProfileModel.fromJson(response.data as Map<String, dynamic>);
      });

  Future<CompanyModel> company(String companyId) => _guard(() async {
        final response = await _dio.get('/entreprises/$companyId');
        return CompanyModel.fromJson(response.data as Map<String, dynamic>);
      });

  /// Réservé à l'administrateur de l'entreprise (403 sinon).
  Future<CompanyModel> updateCompany(
    String companyId, {
    required String name,
    required String businessSector,
    required String address,
  }) =>
      _guard(() async {
        final response = await _dio.patch('/entreprises/$companyId', data: {
          'name': name,
          'businessSector': businessSector,
          'address': address,
        });
        return CompanyModel.fromJson(response.data as Map<String, dynamic>);
      });

  Future<NotificationsPage> notifications({int page = 1, int limit = 20, bool unreadOnly = false}) =>
      _guard(() async {
        final response = await _dio.get('/notifications', queryParameters: {
          'page': page,
          'limit': limit,
          'readStatus': unreadOnly ? 'UNREAD' : 'ALL',
        });
        return NotificationsPage.fromJson(response.data as Map<String, dynamic>);
      });

  Future<void> markNotificationRead(String id) => _guard(() async {
        await _dio.patch('/notifications/$id/lue');
      });
}
