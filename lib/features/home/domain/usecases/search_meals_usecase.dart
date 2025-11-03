import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../repositories/home_repository.dart';

class SearchMealsUseCase {
  final HomeRepository repository;

  SearchMealsUseCase({required this.repository});

  Future<Either<Failure, List<Meal>>> call(String query) async {
    if (query.isEmpty) {
      return const Left(ValidationFailure('Búsqueda vacía'));
    }
    return await repository.searchMeals(query);
  }
}