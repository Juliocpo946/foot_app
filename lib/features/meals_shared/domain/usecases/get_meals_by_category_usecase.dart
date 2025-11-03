import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class GetMealsByCategoryUseCase {
  final MealRepository repository;

  GetMealsByCategoryUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String category) async {
    if (category.isEmpty) {
      return const Left(ValidationFailure('Categoría vacía'));
    }
    return await repository.getMealsByCategory(category);
  }
}