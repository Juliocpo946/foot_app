import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/repositories/meal_repository.dart';

class GetCategoriesUseCase {
  final MealRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}