import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

/// Contrato del perfil guardado en la base de datos.
abstract class ProfileRepository {
  Future<void> createProfile(Profile profile);
}
