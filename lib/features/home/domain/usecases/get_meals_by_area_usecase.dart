import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../../meals_shared/domain/repositories/meal_repository.dart';

class GetMealsByAreaUseCase {
  final MealRepository repository;

  GetMealsByAreaUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String area) async {
    if (area.isEmpty) {
      return const Left(ValidationFailure('Área vacía'));
    }
    return await repository.getMealsByArea(area);
  }
}