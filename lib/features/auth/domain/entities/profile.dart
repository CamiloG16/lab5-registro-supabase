/// Lo que se guarda en la tabla profiles, con el mismo id de la cuenta.
class Profile {
  final String id;
  final String username;
  final String fullName;

  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
  });
}
