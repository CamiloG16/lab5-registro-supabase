import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';

/// El único archivo que usa el SDK de Auth. Convierte la respuesta de
/// Supabase en un [AuthUser].
class SupabaseAuthDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSource(this._client);

  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return _toAuthUser(response.user);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return _toAuthUser(response.user);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  AuthUser _toAuthUser(User? user) {
    if (user == null) {
      throw Exception('Auth no devolvió el usuario');
    }
    return AuthUser(id: user.id, email: user.email ?? '');
  }
}
