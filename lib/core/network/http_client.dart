import 'package:dio/dio.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio dio;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          _logError(error);
          return handler.next(error);
        },
      ),
    );
  }

  void _logError(DioException error) {
    final timestamp = DateTime.now().toString().substring(0, 19);
    final statusCode = error.response?.statusCode ?? 0;
    print('[$timestamp] [HTTP_CLIENT] [ERROR] ${error.message} (Code: $statusCode)');
  }

  void dispose() {
    dio.close();
  }
}