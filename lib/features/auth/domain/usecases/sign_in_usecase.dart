import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';

/// Iniciar sesión también son dos pasos: signIn devuelve el AuthUser y, con
/// su id, getProfile trae el perfil.
class SignInUseCase {
  final AuthRepository _auth;
  final ProfileRepository _profiles;

  SignInUseCase(this._auth, this._profiles);

  Future<(AuthUser, Profile)> call({
    required String email,
    required String password,
  }) async {
    final user = await _auth.signIn(email: email, password: password);
    final profile = await _profiles.getProfile(user.id);
    return (user, profile);
  }
}
