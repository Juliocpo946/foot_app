import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String mealId;
  final String name;
  final double price;
  final int quantity;

  const OrderItem({
    required this.mealId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [mealId, name, price, quantity];
}