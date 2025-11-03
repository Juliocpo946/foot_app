import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<MealModel> getMealById(String id);
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final HttpClient httpClient;

  MealRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<MealModel> getMealById(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.mealDetails}')
        .replace(queryParameters: {'i': id});

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null || data['meals'].isEmpty) {
          throw ServerException('Comida no encontrada');
        }
        return MealModel.fromJson(data['meals'][0]);
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error al obtener detalle', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      AppLogger.logError(
          'MEAL_SHARED_REMOTE', 'Error inesperado: ${e.toString()}');
      throw ServerException('Error del servidor');
    }
  }
}