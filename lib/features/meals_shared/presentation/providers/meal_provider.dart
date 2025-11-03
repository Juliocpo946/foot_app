import 'package:flutter/foundation.dart';
import '../../domain/entities/meal.dart';
import '../../domain/usecases/search_meals_usecase.dart';

enum MealState { initial, loading, loaded, error }

class MealProvider extends ChangeNotifier {
  final SearchMealsUseCase searchMealsUseCase;

  MealProvider({required this.searchMealsUseCase});

  MealState _state = MealState.initial;
  List<Meal> _meals = [];
  String? _errorMessage;

  MealState get state => _state;
  List<Meal> get meals => _meals;
  String? get errorMessage => _errorMessage;

  Future<void> searchMeals(String query) async {
    _state = MealState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await searchMealsUseCase(query);

    result.fold(
          (failure) {
        _state = MealState.error;
        _errorMessage = failure.message;
        _meals = [];
      },
          (meals) {
        _state = MealState.loaded;
        _meals = meals;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = MealState.initial;
    _meals = [];
    _errorMessage = null;
    notifyListeners();
  }
}