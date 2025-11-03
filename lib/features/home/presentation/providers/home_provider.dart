import 'package:flutter/foundation.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../../meals_shared/domain/usecases/get_categories_usecase.dart';
import '../../../meals_shared/domain/usecases/search_meals_usecase.dart';
import '../../../meals_shared/domain/usecases/get_meals_by_category_usecase.dart';

enum HomeState { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final SearchMealsUseCase searchMealsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetMealsByCategoryUseCase getMealsByCategoryUseCase;

  HomeProvider({
    required this.searchMealsUseCase,
    required this.getCategoriesUseCase,
    required this.getMealsByCategoryUseCase,
  });

  HomeState _state = HomeState.initial;
  List<Meal> _meals = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String? _errorMessage;

  HomeState get state => _state;
  List<Meal> get meals => _meals;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories() async {
    final result = await getCategoriesUseCase();

    result.fold(
          (failure) {},
          (categories) {
        _categories = categories;
        notifyListeners();
      },
    );
  }

  Future<void> searchMeals(String query) async {
    _state = HomeState.loading;
    _errorMessage = null;
    _selectedCategory = null;
    notifyListeners();

    final result = await searchMealsUseCase(query);

    result.fold(
          (failure) {
        _state = HomeState.error;
        _errorMessage = failure.message;
        _meals = [];
      },
          (meals) {
        _state = HomeState.loaded;
        _meals = meals;
      },
    );

    notifyListeners();
  }

  Future<void> filterByCategory(String? category) async {
    if (category == null) {
      reset();
      return;
    }

    _state = HomeState.loading;
    _errorMessage = null;
    _selectedCategory = category;
    notifyListeners();

    final result = await getMealsByCategoryUseCase(category);

    result.fold(
          (failure) {
        _state = HomeState.error;
        _errorMessage = failure.message;
        _meals = [];
      },
          (meals) {
        _state = HomeState.loaded;
        _meals = meals;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = HomeState.initial;
    _meals = [];
    _selectedCategory = null;
    _errorMessage = null;
    notifyListeners();
  }
}