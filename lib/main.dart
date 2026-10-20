import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:moviles_auth/features/auth/data/repository/auth_repository_impl.dart';
import 'package:moviles_auth/features/auth/data/repository/profile_repository_impl.dart';
import 'package:moviles_auth/features/auth/data/source/supabase_auth_data_source.dart';
import 'package:moviles_auth/features/auth/data/source/supabase_profile_data_source.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:moviles_auth/features/home/ui/screens/home_screen.dart';
import 'package:moviles_auth/features/login/ui/screens/login_screen.dart';
import 'package:moviles_auth/features/register/ui/bloc/register_bloc.dart';
import 'package:moviles_auth/features/register/ui/screens/register_screen.dart';
import 'package:moviles_auth/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'TU_URL',
    publishableKey: 'TU_PUBLISHABLE_KEY',
  );
  runApp(const App());
}

/// Root widget that declares the theme and the named routes.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moviles Auth',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => BlocProvider(
          create: (_) => RegisterBloc(
            SignUpUseCase(
              AuthRepositoryImpl(
                SupabaseAuthDataSource(Supabase.instance.client),
              ),
              ProfileRepositoryImpl(
                SupabaseProfileDataSource(Supabase.instance.client),
              ),
            ),
          ),
          child: const RegisterScreen(),
        ),
        '/home': (context) {
          final profile =
              ModalRoute.of(context)!.settings.arguments as Profile;
          return HomeScreen(
            username: profile.username,
            fullName: profile.fullName,
          );
        },
      },
    );
  }
}
