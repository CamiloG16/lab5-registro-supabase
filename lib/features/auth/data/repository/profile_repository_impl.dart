import 'package:moviles_auth/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';

/// Cumple el contrato del perfil delegando en el data source.
class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<void> createProfile(Profile profile) {
    return _dataSource.createProfile(profile);
  }
}
