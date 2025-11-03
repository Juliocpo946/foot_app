import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class GetAreasUseCase {
  final HomeRepository repository;

  GetAreasUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getAreas();
  }
}