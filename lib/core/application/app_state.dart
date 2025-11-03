import 'package:flutter/foundation.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AppState extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.unknown;

  AuthStatus get authStatus => _authStatus;

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    _authStatus = AuthStatus.unauthenticated;
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