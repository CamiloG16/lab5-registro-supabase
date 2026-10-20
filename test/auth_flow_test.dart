import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moviles_auth/features/auth/domain/entities/auth_user.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';
import 'package:moviles_auth/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:moviles_auth/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:moviles_auth/features/register/ui/bloc/register_bloc.dart';
import 'package:moviles_auth/features/register/ui/bloc/register_event.dart';
import 'package:moviles_auth/features/register/ui/bloc/register_state.dart';
import 'package:moviles_auth/features/register/ui/screens/register_screen.dart';

class FakeAuthRepository implements AuthRepository {
  bool signedOut = false;

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    if (email == 'ya@existe.com') throw Exception('User already registered');
    return AuthUser(id: 'uid-1', email: email);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async => AuthUser(id: 'uid-1', email: email);

  @override
  Future<void> signOut() async => signedOut = true;
}

class FakeProfileRepository implements ProfileRepository {
  final bool fail;
  final saved = <Profile>[];

  FakeProfileRepository({this.fail = false});

  @override
  Future<void> createProfile(Profile profile) async {
    if (fail) throw Exception('permission denied for table profiles');
    saved.add(profile);
  }

  @override
  Future<Profile> getProfile(String id) async =>
      Profile(id: id, username: 'ana', fullName: 'Ana Gómez');
}

void main() {
  test('SignUpUseCase guarda el perfil con el id que devolvió Auth', () async {
    final profiles = FakeProfileRepository();
    final signUp = SignUpUseCase(FakeAuthRepository(), profiles);

    final profile = await signUp(
      username: 'ana',
      fullName: 'Ana Gómez',
      email: 'ana@icesi.edu.co',
      password: '123456',
    );

    expect(profile.id, 'uid-1');
    expect(profiles.saved.single.username, 'ana');
    expect(profiles.saved.single.fullName, 'Ana Gómez');
  });

  test('si createProfile falla, SignUpUseCase cierra la sesión y avisa', () async {
    final auth = FakeAuthRepository();
    final signUp = SignUpUseCase(auth, FakeProfileRepository(fail: true));

    await expectLater(
      signUp(username: 'a', fullName: 'A', email: 'a@a.com', password: '123456'),
      throwsException,
    );
    expect(auth.signedOut, isTrue);
  });

  test('SignInUseCase trae el AuthUser y su perfil', () async {
    final signIn = SignInUseCase(FakeAuthRepository(), FakeProfileRepository());
    final (user, profile) = await signIn(
      email: 'ana@icesi.edu.co',
      password: '123456',
    );
    expect(user.email, 'ana@icesi.edu.co');
    expect(profile.id, user.id);
  });

  test('RegisterBloc pasa por loading y termina en success', () async {
    final bloc = RegisterBloc(
      SignUpUseCase(FakeAuthRepository(), FakeProfileRepository()),
    );
    final statuses = <RegisterStatus>[];
    final sub = bloc.stream.listen((s) => statuses.add(s.status));

    bloc.add(
      RegisterSubmitted(
        username: 'ana',
        fullName: 'Ana Gómez',
        email: 'ana@icesi.edu.co',
        password: '123456',
      ),
    );
    await bloc.stream.firstWhere((s) => s.status == RegisterStatus.success);

    expect(statuses, [RegisterStatus.loading, RegisterStatus.success]);
    expect(bloc.state.profile?.username, 'ana');
    await sub.cancel();
    await bloc.close();
  });

  test('RegisterBloc emite failure con el mensaje si Auth falla', () async {
    final bloc = RegisterBloc(
      SignUpUseCase(FakeAuthRepository(), FakeProfileRepository()),
    );
    bloc.add(
      RegisterSubmitted(
        username: 'ana',
        fullName: 'Ana',
        email: 'ya@existe.com',
        password: '123456',
      ),
    );
    await bloc.stream.firstWhere((s) => s.status == RegisterStatus.failure);
    expect(bloc.state.errorMessage, 'User already registered');
    await bloc.close();
  });

  testWidgets('RegisterScreen rechaza contraseñas que no coinciden', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => RegisterBloc(
            SignUpUseCase(FakeAuthRepository(), FakeProfileRepository()),
          ),
          child: const RegisterScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'ana');
    await tester.enterText(find.byType(TextField).at(1), 'Ana Gómez');
    await tester.enterText(find.byType(TextField).at(2), 'ana@icesi.edu.co');
    await tester.enterText(find.byType(TextField).at(3), '123456');
    await tester.enterText(find.byType(TextField).at(4), '654321');
    final button = find.widgetWithText(FilledButton, 'Registrarme');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
  });
}
