import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../meals_shared/data/models/meal_model.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HttpClient httpClient;

  HomeRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchMeal}')
        .replace(queryParameters: {'s': query});

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error en búsqueda', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      AppLogger.logError('HOME_REMOTE', 'Error inesperado: ${e.toString()}');
      throw ServerException('Error del servidor');
    }
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    final uri =
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterByCategory}')
        .replace(queryParameters: {'c': category});

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }

        List<MealModel> meals = [];
        for (var item in (data['meals'] as List)) {
          try {
            final mealStub = MealModel.fromJson({
              'idMeal': item['idMeal'],
              'strMeal': item['strMeal'],
              'strMealThumb': item['strMealThumb'],
              'strCategory': category,
            });
            meals.add(mealStub);
          } catch (e) {
            continue;
          }
        }
        return meals;
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error al filtrar', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error del servidor');
    }
  }

  @override
  Future<List<MealModel>> getMealsByArea(String area) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterByArea}')
        .replace(queryParameters: {'a': area});

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }

        List<MealModel> meals = [];
        for (var item in (data['meals'] as List)) {
          try {
            final mealStub = MealModel.fromJson({
              'idMeal': item['idMeal'],
              'strMeal': item['strMeal'],
              'strMealThumb': item['strMealThumb'],
              'strArea': area,
            });
            meals.add(mealStub);
          } catch (e) {
            continue;
          }
        }
        return meals;
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error al filtrar por área', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error del servidor');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final uri =
    Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listCategories}');

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] == null) {
          return [];
        }
        return (data['categories'] as List)
            .map((json) => json['strCategory'] as String)
            .toList();
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error al obtener categorías', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error del servidor');
    }
  }

  @override
  Future<List<String>> getAreas() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.listAreas}');

    try {
      final response = await httpClient.client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null) {
          return [];
        }
        return (data['meals'] as List)
            .map((json) => json['strArea'] as String)
            .toList();
      }

      httpClient.logError(uri.toString(), response.statusCode, response.body);
      throw ServerException('Error al obtener áreas', response.statusCode);
    } on http.ClientException {
      throw NetworkException('Sin conexión');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Error del servidor');
    }
  }
}