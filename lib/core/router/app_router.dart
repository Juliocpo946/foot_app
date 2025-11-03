import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/meal_detail/presentation/pages/meal_detail_screen.dart';
import '../../features/favorites/presentation/pages/favorites_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../application/app_state.dart';
import 'routes.dart';

class AppRouter {
  final AppState appState;

  AppRouter({required this.appState});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashPath,
    refreshListenable: appState,
    routes: [
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.mealDetailPath,
        name: AppRoutes.mealDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MealDetailScreen(mealId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.favoritesPath,
        name: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.profilePath,
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final loc = state.matchedLocation;

      final isGoingToSplash = loc == AppRoutes.splashPath;
      final isGoingToLogin = loc == AppRoutes.loginPath;
      final isGoingToRegister = loc == AppRoutes.registerPath;
      final isGoingToAuth = isGoingToLogin || isGoingToRegister;

      if (authStatus == AuthStatus.unknown) {
        return isGoingToSplash ? null : AppRoutes.splashPath;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        return isGoingToAuth || isGoingToSplash ? null : AppRoutes.loginPath;
      }

      if (authStatus == AuthStatus.authenticated) {
        return isGoingToAuth || isGoingToSplash ? AppRoutes.homePath : null;
      }

      return null;
    },
  );
}