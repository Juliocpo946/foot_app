import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../../meals_shared/domain/repositories/meal_repository.dart';

class GetMealByIdUseCase {
  final MealRepository repository;

  GetMealByIdUseCase({required this.repository});

  Future<Either<Failure, Meal>> call(String id) async {
    if (id.isEmpty) {
      return const Left(ValidationFailure('ID vacío'));
    }
    return await repository.getMealById(id);
  }
}