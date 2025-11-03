import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}