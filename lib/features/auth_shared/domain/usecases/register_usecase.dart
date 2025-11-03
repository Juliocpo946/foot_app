import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, User>> call(
      String email,
      String password,
      String name,
      ) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return const Left(
        ValidationFailure('Todos los campos son requeridos'),
      );
    }
    if (!email.contains('@')) {
      return const Left(ValidationFailure('Email inválido'));
    }
    if (password.length < 6) {
      return const Left(
        ValidationFailure('La contraseña debe tener al menos 6 caracteres'),
      );
    }
    return await repository.register(email, password, name);
  }
}