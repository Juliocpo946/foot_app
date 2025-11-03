import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, User>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return const Left(ValidationFailure('Email y contraseña requeridos'));
    }
    return await repository.login(email, password);
  }
}