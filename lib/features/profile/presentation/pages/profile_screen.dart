import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/application/app_state.dart';
import '../../../../shared/components/atoms/primary_button.dart';
import '../../../../shared/components/molecules/loading_widget.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.loadUser().then((_) {
        if (provider.user != null) {
          _nameController.text = provider.user!.name;
          _emailController.text = provider.user!.email;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(ProfileProvider provider) async {
    if (_formKey.currentState!.validate()) {
      final success = await provider.saveChanges(
        _nameController.text,
        _emailController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Perfil actualizado'
                : provider.errorMessage ?? 'Error al actualizar'),
            backgroundColor:
            success ? Colors.green : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _confirmDeleteAccount(ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar cuenta'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Eliminar'),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final success = await provider.deleteAccount();
                if (success && mounted) {
                  Provider.of<AppState>(context, listen: false).logout();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.state == ProfileState.loading ||
              provider.state == ProfileState.initial) {
            return const LoadingWidget(message: 'Cargando perfil...');
          }

          if (provider.state == ProfileState.error || provider.user == null) {
            return Center(
              child: Text(provider.errorMessage ?? 'No se pudo cargar el perfil'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      _buildProfileImage(provider),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _nameController,
                        decoration:
                        const InputDecoration(labelText: 'Nombre Completo'),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? 'El nombre es requerido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Correo Electrónico'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El email es requerido';
                          }
                          if (!value.contains('@')) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'Guardar Cambios',
                        onPressed: () => _saveChanges(provider),
                        isLoading: provider.state == ProfileState.saving,
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => _confirmDeleteAccount(provider),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text('Eliminar Cuenta'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(ProfileProvider provider) {
    final theme = Theme.of(context);
    ImageProvider? image;
    if (provider.profileImage != null) {
      image = FileImage(provider.profileImage!);
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: image,
          backgroundColor: theme.colorScheme.surfaceVariant,
          child: image == null
              ? Icon(
            Icons.person,
            size: 60,
            color: theme.colorScheme.onSurfaceVariant,
          )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: provider.pickImage,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}