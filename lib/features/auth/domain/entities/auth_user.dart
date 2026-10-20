/// Lo que devuelve Auth: la cuenta, sin la contraseña.
class AuthUser {
  final String id;
  final String email;

  const AuthUser({required this.id, required this.email});
}
