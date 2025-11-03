abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, [this.code]);
}

class ServerException extends AppException {
  ServerException([super.message = "Error en el servidor", super.code]);
}

class NetworkException extends AppException {
  NetworkException([super.message = "Error de red", super.code]);
}

class CacheException extends AppException {
  CacheException([super.message = "Error de almacenamiento", super.code]);
}

class ValidationException extends AppException {
  ValidationException([super.message = "Error de validación", super.code]);
}