import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/application/app_state.dart';
import '../../../../shared/components/atoms/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 48 : 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isTablet ? 80 : 60,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: isTablet ? 80 : 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Usuario',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'usuario@email.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: isTablet ? 300 : double.infinity,
                child: PrimaryButton(
                  text: 'Cerrar Sesión',
                  onPressed: () {
                    Provider.of<AppState>(context, listen: false).logout();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}