import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/failures.dart';
import '../../../meals_shared/domain/entities/meal.dart';
import '../../domain/usecases/get_areas_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_meals_by_area_usecase.dart';
import '../../domain/usecases/get_meals_by_category_usecase.dart';
import '../../domain/usecases/search_meals_usecase.dart';

enum HomeState { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final SearchMealsUseCase searchMealsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetMealsByCategoryUseCase getMealsByCategoryUseCase;
  final GetAreasUseCase getAreasUseCase;
  final GetMealsByAreaUseCase getMealsByAreaUseCase;

  HomeProvider({
    required this.searchMealsUseCase,
    required this.getCategoriesUseCase,
    required this.getMealsByCategoryUseCase,
    required this.getAreasUseCase,
    required this.getMealsByAreaUseCase,
  });

  HomeState _state = HomeState.initial;
  List<Meal> _meals = [];
  List<String> _categories = [];
  List<String> _areas = [];
  String? _selectedCategory;
  String? _selectedArea;
  String? _errorMessage;

  HomeState get state => _state;
  List<Meal> get meals => _meals;
  List<String> get categories => _categories;
  List<String> get areas => _areas;
  String? get selectedCategory => _selectedCategory;
  String? get selectedArea => _selectedArea;
  String? get errorMessage => _errorMessage;

  Future<void> loadInitialData() async {
    loadCategories();
    loadAreas();
  }

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

  Future<void> loadAreas() async {
    final result = await getAreasUseCase();
    result.fold(
          (failure) {},
          (areas) {
        _areas = areas;
        notifyListeners();
      },
    );
  }

  Future<void> searchMeals(String query) async {
    _state = HomeState.loading;
    _errorMessage = null;
    _selectedCategory = null;
    _selectedArea = null;
    notifyListeners();

    final result = await searchMealsUseCase(query);
    _handleResult(result);
  }

  Future<void> filterByCategory(String? category) async {
    if (category == null) {
      reset();
      return;
    }

    _state = HomeState.loading;
    _errorMessage = null;
    _selectedCategory = category;
    _selectedArea = null;
    notifyListeners();

    final result = await getMealsByCategoryUseCase(category);
    _handleResult(result);
  }

  Future<void> filterByArea(String? area) async {
    if (area == null) {
      reset();
      return;
    }

    _state = HomeState.loading;
    _errorMessage = null;
    _selectedArea = area;
    _selectedCategory = null;
    notifyListeners();

    final result = await getMealsByAreaUseCase(area);
    _handleResult(result);
  }

  void _handleResult(Either<Failure, List<Meal>> result) {
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
    _selectedArea = null;
    _errorMessage = null;
    notifyListeners();
  }
}