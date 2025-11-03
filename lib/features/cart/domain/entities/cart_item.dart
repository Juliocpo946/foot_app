import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String mealId;
  final String name;
  final double price;
  final String thumbnail;
  final String category;
  final int quantity;

  const CartItem({
    required this.mealId,
    required this.name,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [mealId, name, price, thumbnail, category, quantity];
}