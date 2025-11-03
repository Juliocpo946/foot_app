import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';

abstract class MealRepository {
  Future<Either<Failure, List<Meal>>> searchMeals(String query);
  Future<Either<Failure, List<Meal>>> getMealsByCategory(String category);
  Future<Either<Failure, Meal>> getMealById(String id);
  Future<Either<Failure, List<String>>> getCategories();
}