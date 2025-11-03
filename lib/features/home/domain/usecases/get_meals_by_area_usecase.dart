import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../repositories/home_repository.dart';

class GetMealsByAreaUseCase {
  final HomeRepository repository;

  GetMealsByAreaUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String area) async {
    if (area.isEmpty) {
      return const Left(ValidationFailure('Área vacía'));
    }
    return await repository.getMealsByArea(area);
  }
}