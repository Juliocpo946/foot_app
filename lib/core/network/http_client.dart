import 'package:http/http.dart' as http;
import '../../core/utils/logger.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final http.Client client;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    client = http.Client();
  }

  void logError(String url, int statusCode, String body) {
    AppLogger.logError(
      'HTTP_CLIENT',
      'Error en $url (Code: $statusCode)',
      body,
    );
  }

  void dispose() {
    client.close();
  }
}