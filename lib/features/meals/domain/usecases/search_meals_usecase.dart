import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class SearchMealsUseCase {
  final MealRepository repository;

  SearchMealsUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String query) async {
    if (query.isEmpty) {
      return const Left(ValidationFailure('Búsqueda vacía'));
    }
    return await repository.searchMeals(query);
  }
}