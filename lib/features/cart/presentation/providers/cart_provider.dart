import 'package:flutter/foundation.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

enum CartState { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository cartRepository;

  CartProvider({required this.cartRepository});

  CartState _state = CartState.initial;
  List<CartItem> _items = [];
  String? _errorMessage;

  CartState get state => _state;
  List<CartItem> get items => _items;
  String? get errorMessage => _errorMessage;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);

  Future<void> loadCart() async {
    _state = CartState.loading;
    notifyListeners();

    final result = await cartRepository.getCartItems();
    result.fold(
          (failure) {
        _state = CartState.error;
        _errorMessage = failure.message;
      },
          (items) {
        _items = items;
        _state = CartState.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    final result = await cartRepository.addToCart(item);
    result.fold(
          (failure) {
        _errorMessage = failure.message;
      },
          (_) {
        loadCart();
      },
    );
  }

  Future<void> updateQuantity(String mealId, int quantity) async {
    final result = await cartRepository.updateQuantity(mealId, quantity);
    result.fold(
          (failure) {
        _errorMessage = failure.message;
      },
          (_) {
        loadCart();
      },
    );
  }

  Future<void> removeItem(String mealId) async {
    final result = await cartRepository.removeFromCart(mealId);
    result.fold(
          (failure) {
        _errorMessage = failure.message;
      },
          (_) {
        loadCart();
      },
    );
  }

  Future<void> clearCart() async {
    final result = await cartRepository.clearCart();
    result.fold(
          (failure) {
        _errorMessage = failure.message;
      },
          (_) {
        _items = [];
        _state = CartState.loaded;
        notifyListeners();
      },
    );
  }
}