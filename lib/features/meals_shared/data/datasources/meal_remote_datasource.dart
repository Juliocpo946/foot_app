import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/logger.dart';
import '../models/meal_model.dart';

abstract class MealRemoteDataSource {
  Future<List<MealModel>> searchMeals(String query);
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<List<MealModel>> getMealsByArea(String area);
  Future<MealModel> getMealById(String id);
  Future<List<String>> getCategories();
  Future<List<String>> getAreas();
}

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  final HttpClient httpClient;

  MealRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.searchMeal}',
        queryParameters: {'s': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) {
          return [];
        }
        return (data['meals'] as List)
            .map((json) => MealModel.fromJson(json))
            .toList();
      }

      throw ServerException('Error en búsqueda', response.statusCode);
    } on DioException catch (e) {
      AppLogger.logError('MEAL_REMOTE', 'Error de red', e.response?.statusCode);
      throw NetworkException('Sin conexión');
    } catch (e) {
      AppLogger.logError('MEAL_REMOTE', 'Error inesperado: ${e.toString()}');
      throw ServerException('Error del servidor');
    }
  }

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.filterByCategory}',
        queryParameters: {'c': category},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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

      throw ServerException('Error al filtrar', response.statusCode);
    } on DioException {
      throw NetworkException('Sin conexión');
    }
  }

  @override
  Future<List<MealModel>> getMealsByArea(String area) async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.filterByArea}',
        queryParameters: {'a': area},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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

      throw ServerException('Error al filtrar por área', response.statusCode);
    } on DioException {
      throw NetworkException('Sin conexión');
    }
  }

  @override
  Future<MealModel> getMealById(String id) async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.mealDetails}',
        queryParameters: {'i': id},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null || data['meals'].isEmpty) {
          throw ServerException('Comida no encontrada');
        }
        return MealModel.fromJson(data['meals'][0]);
      }

      throw ServerException('Error al obtener detalle', response.statusCode);
    } on DioException {
      throw NetworkException('Sin conexión');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.listCategories}',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['categories'] == null) {
          return [];
        }
        return (data['categories'] as List)
            .map((json) => json['strCategory'] as String)
            .toList();
      }

      throw ServerException('Error al obtener categorías', response.statusCode);
    } on DioException {
      throw NetworkException('Sin conexión');
    }
  }

  @override
  Future<List<String>> getAreas() async {
    try {
      final response = await httpClient.dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.listAreas}',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['meals'] == null) {
          return [];
        }
        return (data['meals'] as List)
            .map((json) => json['strArea'] as String)
            .toList();
      }

      throw ServerException('Error al obtener áreas', response.statusCode);
    } on DioException {
      throw NetworkException('Sin conexión');
    }
  }
}