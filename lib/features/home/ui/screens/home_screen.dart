import 'package:flutter/material.dart';

import 'package:moviles_auth/components/primary_button.dart';
import 'package:moviles_auth/components/profile_field.dart';
import 'package:moviles_auth/theme/app_theme.dart';

/// Shows the profile of the signed in user and lets them sign out.
class HomeScreen extends StatelessWidget {
  final String username;
  final String fullName;
  final String email;

  const HomeScreen({
    super.key,
    this.username = 'usuario',
    this.fullName = 'Nombre Apellido',
    this.email = 'correo@ejemplo.com',
  });

  void _signOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  fullName.isEmpty ? '?' : fullName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@$username',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              ProfileField(
                icon: Icons.alternate_email,
                label: 'Nombre de usuario',
                value: username,
              ),
              const SizedBox(height: 12),
              ProfileField(
                icon: Icons.person_outline,
                label: 'Nombre completo',
                value: fullName,
              ),
              const SizedBox(height: 12),
              ProfileField(
                icon: Icons.mail_outline,
                label: 'Correo',
                value: email,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Cerrar sesión',
                onPressed: () => _signOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
