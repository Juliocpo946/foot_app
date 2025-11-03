import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Meal>>> searchMeals(String query);
  Future<Either<Failure, List<Meal>>> getMealsByCategory(String category);
  Future<Either<Failure, List<Meal>>> getMealsByArea(String area);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<String>>> getAreas();
}