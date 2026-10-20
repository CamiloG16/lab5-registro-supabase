import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviles_auth/components/error_message.dart';
import 'package:moviles_auth/components/primary_button.dart';
import 'package:moviles_auth/features/home/ui/screens/home_screen.dart';
import 'package:moviles_auth/features/login/ui/bloc/login_bloc.dart';
import 'package:moviles_auth/features/login/ui/bloc/login_event.dart';
import 'package:moviles_auth/features/login/ui/bloc/login_state.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// Sign in form with email and password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Solo para la validación de campos vacíos, que se queda en la pantalla.
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Escribe tu correo y tu contraseña');
      return;
    }
    setState(() => _errorMessage = null);
    context.read<LoginBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: HomeArguments(
                    profile: state.profile!,
                    email: state.user!.email,
                  ),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) => _form(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(LoginState state) {
    final isLoading = state.status == LoginStatus.loading;
    final errorMessage = _errorMessage ??
        (state.status == LoginStatus.failure ? state.errorMessage : null);
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido de nuevo',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa con tu correo y tu contraseña',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              if (errorMessage != null) ...[
                ErrorMessage(message: errorMessage),
                const SizedBox(height: 16),
              ],
              PrimaryButton(
                label: 'Iniciar sesión',
                isLoading: isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/register'),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ),
            ],
          );
  }
}
