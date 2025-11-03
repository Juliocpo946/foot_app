import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../../meals_shared/domain/repositories/meal_repository.dart';

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