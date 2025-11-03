import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.mealId,
    required super.name,
    required super.price,
    required super.thumbnail,
    required super.category,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      mealId: json['mealId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealId': mealId,
      'name': name,
      'price': price,
      'thumbnail': thumbnail,
      'category': category,
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      mealId: mealId,
      name: name,
      price: price,
      thumbnail: thumbnail,
      category: category,
      quantity: quantity ?? this.quantity,
    );
  }
}