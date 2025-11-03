import 'package:flutter/foundation.dart';
import '../../features/auth_shared/domain/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  final AuthRepository authRepository;

  AppState({required this.authRepository});

  AuthStatus _authStatus = AuthStatus.unknown;

  AuthStatus get authStatus => _authStatus;

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    final result = await authRepository.getCurrentUser();

    result.fold(
          (failure) {
        _authStatus = AuthStatus.unauthenticated;
      },
          (user) {
        _authStatus = user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated;
      },
    );

    notifyListeners();
  }

  void login() {
    _authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}