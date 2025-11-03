import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(CartItem item);
  Future<Either<Failure, void>> updateQuantity(String mealId, int quantity);
  Future<Either<Failure, void>> removeFromCart(String mealId);
  Future<Either<Failure, void>> clearCart();
}