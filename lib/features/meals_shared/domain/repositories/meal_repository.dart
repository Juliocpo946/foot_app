import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';

abstract class MealRepository {
  Future<Either<Failure, Meal>> getMealById(String id);
}