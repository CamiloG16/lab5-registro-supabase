import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';

/// Cierra la sesión en Auth antes de volver a /login.
class SignOutUseCase {
  final AuthRepository _auth;

  SignOutUseCase(this._auth);

  Future<void> call() => _auth.signOut();
}
