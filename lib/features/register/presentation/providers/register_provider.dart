import 'package:flutter/foundation.dart';
import '../../../auth_shared/domain/entities/user.dart';
import '../../domain/usecases/register_usecase.dart';

enum RegisterState { initial, loading, success, error }

class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  RegisterProvider({required this.registerUseCase});

  RegisterState _state = RegisterState.initial;
  String? _errorMessage;
  User? _user;

  RegisterState get state => _state;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  Future<void> register(String email, String password, String name) async {
    _state = RegisterState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase(email, password, name);

    result.fold(
          (failure) {
        _state = RegisterState.error;
        _errorMessage = failure.message;
      },
          (user) {
        _state = RegisterState.success;
        _user = user;
      },
    );

    notifyListeners();
  }

  void reset() {
    _state = RegisterState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}