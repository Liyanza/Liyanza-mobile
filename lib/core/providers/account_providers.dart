import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart'; // apiClientProvider
import '../../data/datasources/account_remote_datasource.dart';
import '../../data/models/account/account_models.dart';

final accountRemoteDatasourceProvider = Provider(
  (ref) => AccountRemoteDatasource(ref.read(apiClientProvider).dio),
);

class AccountData {
  final ProfileModel profile;

  /// null tant que l'utilisateur n'a pas d'entreprise.
  final CompanyModel? company;

  const AccountData({required this.profile, this.company});
}

final accountProvider = FutureProvider.autoDispose<AccountData>((ref) async {
  final datasource = ref.read(accountRemoteDatasourceProvider);
  final profile = await datasource.profile();
  final companyId = profile.companyId;
  final company = companyId == null ? null : await datasource.company(companyId);
  return AccountData(profile: profile, company: company);
});
