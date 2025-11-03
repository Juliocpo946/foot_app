import 'package:flutter/foundation.dart';
import '../../../auth_shared/domain/entities/user.dart';
import '../../../auth_shared/domain/usecases/login_usecase.dart';

enum LoginState { initial, loading, success, error }

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider({required this.loginUseCase});

  LoginState _state = LoginState.initial;
  String? _errorMessage;
  User? _user;

  LoginState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(email, password);

    result.fold(
          (failure) {
        _state = LoginState.error;
        _errorMessage = failure.message;
      },
          (user) {
        _state = LoginState.success;
        _user = user;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = LoginState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}