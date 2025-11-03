import '../../../meals_shared/data/models/meal_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MealModel>> searchMeals(String query);
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<List<MealModel>> getMealsByArea(String area);
  Future<List<String>> getCategories();
  Future<List<String>> getAreas();
}