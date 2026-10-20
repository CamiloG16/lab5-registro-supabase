import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

/// El insert en la tabla profiles. En Dart el campo se llama fullName; en la
/// tabla, la columna es full_name. Solo este archivo lo sabe.
class SupabaseProfileDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSource(this._client);

  Future<void> createProfile(Profile profile) async {
    final row = {
      'id': profile.id,
      'username': profile.username,
      'full_name': profile.fullName,
    };
    try {
      await _client.from('profiles').insert(row);
    } on PostgrestException catch (e) {
      // REVISAR: si tu tabla profiles tiene la columna email como NOT NULL,
      // el insert sin ella falla con el código 23502. En ese caso se reintenta
      // con el correo de la sesión que acaba de abrir signUp. Si tu tabla solo
      // tiene id, username y full_name, este bloque nunca se ejecuta.
      final missingEmail = e.code == '23502' && e.message.contains('email');
      if (!missingEmail) throw Exception(e.message);
      try {
        await _client.from('profiles').insert({
          ...row,
          'email': _client.auth.currentUser?.email,
        });
      } on PostgrestException catch (e) {
        throw Exception(e.message);
      }
    }
  }
}
