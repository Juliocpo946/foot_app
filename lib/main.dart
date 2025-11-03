import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/my_app.dart';
import 'core/application/app_state.dart';
import 'core/network/http_client.dart';
import 'core/router/app_router.dart';

import 'features/auth_shared/data/datasources/auth_local_datasource.dart';
import 'features/auth_shared/data/repositories/auth_repository_impl.dart';
import 'features/auth_shared/domain/usecases/login_usecase.dart';
import 'features/auth_shared/domain/usecases/register_usecase.dart';

import 'features/splash/presentation/providers/splash_provider.dart';
import 'features/login/presentation/providers/login_provider.dart';
import 'features/register/presentation/providers/register_provider.dart';

import 'features/meals_shared/data/datasources/meal_remote_datasource.dart';
import 'features/meals_shared/data/repositories/meal_repository_impl.dart';
import 'features/meals_shared/domain/usecases/search_meals_usecase.dart';
import 'features/meals_shared/domain/usecases/get_categories_usecase.dart';
import 'features/meals_shared/domain/usecases/get_meals_by_category_usecase.dart';

import 'features/home/presentation/providers/home_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = HttpClient();

  final authLocalDataSource = AuthLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  final authRepository = AuthRepositoryImpl(
    localDataSource: authLocalDataSource,
  );
  final loginUseCase = LoginUseCase(repository: authRepository);
  final registerUseCase = RegisterUseCase(repository: authRepository);

  final mealRemoteDataSource = MealRemoteDataSourceImpl(
    httpClient: httpClient,
  );
  final mealRepository = MealRepositoryImpl(
    remoteDataSource: mealRemoteDataSource,
  );
  final searchMealsUseCase = SearchMealsUseCase(repository: mealRepository);
  final getCategoriesUseCase = GetCategoriesUseCase(repository: mealRepository);
  final getMealsByCategoryUseCase =
  GetMealsByCategoryUseCase(repository: mealRepository);


  final appState = AppState();
  final appRouter = AppRouter(appState: appState);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider(
          create: (_) => SplashProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(loginUseCase: loginUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(registerUseCase: registerUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            searchMealsUseCase: searchMealsUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            getMealsByCategoryUseCase: getMealsByCategoryUseCase,
          ),
        ),
      ],
      child: MyApp(router: appRouter),
    ),
  );
}