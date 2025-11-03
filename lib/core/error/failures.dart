import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = "Error en el servidor", super.code]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "Error de red", super.code]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = "Error de almacenamiento", super.code]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = "Error de validación", super.code]);
}