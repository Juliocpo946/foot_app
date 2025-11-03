import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';

enum OrdersState { initial, loading, loaded, error }

class OrdersProvider extends ChangeNotifier {
  final OrdersRepository ordersRepository;

  OrdersProvider({required this.ordersRepository});

  OrdersState _state = OrdersState.initial;
  List<Order> _orders = [];
  String? _errorMessage;

  OrdersState get state => _state;
  List<Order> get orders => _orders;
  String? get errorMessage => _errorMessage;

  Future<void> loadOrders() async {
    _state = OrdersState.loading;
    notifyListeners();

    final result = await ordersRepository.getOrders();
    result.fold(
          (failure) {
        _state = OrdersState.error;
        _errorMessage = failure.message;
      },
          (orders) {
        _orders = orders;
        _state = OrdersState.loaded;
      },
    );

    notifyListeners();
  }

  Future<bool> createOrder(Order order) async {
    final result = await ordersRepository.createOrder(order);
    bool success = false;
    result.fold(
          (failure) {
        _errorMessage = failure.message;
        success = false;
      },
          (_) {
        loadOrders();
        success = true;
      },
    );

    return success;
  }
}