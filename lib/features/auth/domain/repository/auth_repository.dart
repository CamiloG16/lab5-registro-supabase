import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';

/// Contrato de autenticación: qué se puede pedir, sin decir quién lo cumple.
abstract class AuthRepository {
  Future<AuthUser> signUp({required String email, required String password});
}
