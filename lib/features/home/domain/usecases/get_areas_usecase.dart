import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/repositories/meal_repository.dart';

class GetAreasUseCase {
  final MealRepository repository;

  GetAreasUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getAreas();
  }
}