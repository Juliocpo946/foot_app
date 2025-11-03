import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../repositories/home_repository.dart';

class GetMealsByCategoryUseCase {
  final HomeRepository repository;

  GetMealsByCategoryUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String category) async {
    if (category.isEmpty) {
      return const Left(ValidationFailure('Categoría vacía'));
    }
    return await repository.getMealsByCategory(category);
  }
}