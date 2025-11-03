import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/my_app.dart';
import 'core/application/app_state.dart';
import 'core/network/http_client.dart';
import 'core/router/app_router.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/meals/data/datasources/meal_remote_datasource.dart';
import 'features/meals/data/repositories/meal_repository_impl.dart';
import 'features/meals/domain/usecases/search_meals_usecase.dart';
import 'features/meals/presentation/providers/meal_provider.dart';

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

  final mealRemoteDataSource = MealRemoteDataSourceImpl(
    httpClient: httpClient,
  );
  final mealRepository = MealRepositoryImpl(
    remoteDataSource: mealRemoteDataSource,
  );
  final searchMealsUseCase = SearchMealsUseCase(repository: mealRepository);

  final appState = AppState();
  final appRouter = AppRouter(appState: appState);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(loginUseCase: loginUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => MealProvider(searchMealsUseCase: searchMealsUseCase),
        ),
      ],
      child: MyApp(router: appRouter),
    ),
  );
}