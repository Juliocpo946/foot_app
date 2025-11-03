import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      final cartItems = await localDataSource.getCartItems();
      final existingIndex = cartItems.indexWhere((i) => i.mealId == item.mealId);

      if (existingIndex != -1) {
        final existingItem = cartItems[existingIndex];
        final updatedItem = CartItemModel(
          mealId: existingItem.mealId,
          name: existingItem.name,
          price: existingItem.price,
          thumbnail: existingItem.thumbnail,
          category: existingItem.category,
          quantity: existingItem.quantity + item.quantity,
        );
        await localDataSource.updateCartItem(updatedItem);
      } else {
        final newItem = CartItemModel(
          mealId: item.mealId,
          name: item.name,
          price: item.price,
          thumbnail: item.thumbnail,
          category: item.category,
          quantity: item.quantity,
        );
        await localDataSource.addCartItem(newItem);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String mealId, int quantity) async {
    try {
      if (quantity <= 0) {
        await localDataSource.removeCartItem(mealId);
      } else {
        final cartItems = await localDataSource.getCartItems();
        final item = cartItems.firstWhere((i) => i.mealId == mealId);
        final updatedItem = CartItemModel(
          mealId: item.mealId,
          name: item.name,
          price: item.price,
          thumbnail: item.thumbnail,
          category: item.category,
          quantity: quantity,
        );
        await localDataSource.updateCartItem(updatedItem);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String mealId) async {
    try {
      await localDataSource.removeCartItem(mealId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}