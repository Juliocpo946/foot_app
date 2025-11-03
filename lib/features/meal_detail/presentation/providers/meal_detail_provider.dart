import 'package:flutter/foundation.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../domain/usecases/get_meal_by_id_usecase.dart';

enum MealDetailState { initial, loading, loaded, error }

class MealDetailProvider extends ChangeNotifier {
  final GetMealByIdUseCase getMealByIdUseCase;

  MealDetailProvider({required this.getMealByIdUseCase});

  MealDetailState _state = MealDetailState.initial;
  Meal? _meal;
  String? _errorMessage;

  MealDetailState get state => _state;
  Meal? get meal => _meal;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMealDetail(String id) async {
    _state = MealDetailState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getMealByIdUseCase(id);

    result.fold(
          (failure) {
        _state = MealDetailState.error;
        _errorMessage = failure.message;
      },
          (meal) {
        _state = MealDetailState.loaded;
        _meal = meal;
      },
    );

    notifyListeners();
  }
}