import 'package:flutter/foundation.dart';
import '../../../auth_shared/domain/repositories/auth_repository.dart';

enum SplashState { loading, authenticated, unauthenticated }

class SplashProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  SplashProvider({required this.authRepository});

  SplashState _state = SplashState.loading;

  SplashState get state => _state;

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await authRepository.getCurrentUser();

    result.fold(
          (failure) {
        _state = SplashState.unauthenticated;
      },
          (user) {
        _state = user != null
            ? SplashState.authenticated
            : SplashState.unauthenticated;
      },
    );

    notifyListeners();
  }
}