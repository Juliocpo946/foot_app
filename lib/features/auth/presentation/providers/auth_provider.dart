import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

enum AuthState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  AuthProvider({required this.loginUseCase});

  AuthState _state = AuthState.initial;
  String? _errorMessage;
  User? _user;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(email, password);

    result.fold(
          (failure) {
        _state = AuthState.error;
        _errorMessage = failure.message;
      },
          (user) {
        _state = AuthState.success;
        _user = user;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = AuthState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}