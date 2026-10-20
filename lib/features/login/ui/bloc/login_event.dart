abstract class LoginEvent {}

/// Se lanza cuando el usuario toca "Iniciar sesión" con los campos llenos.
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}
