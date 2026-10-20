import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

enum LoginStatus { initial, loading, success, failure }

/// Misma forma que RegisterState: un solo estado con copyWith.
class LoginState {
  final LoginStatus status;
  final AuthUser? user;
  final Profile? profile;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.profile,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    AuthUser? user,
    Profile? profile,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
