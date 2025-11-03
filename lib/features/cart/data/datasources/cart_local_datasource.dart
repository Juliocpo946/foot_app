import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem(CartItemModel item);
  Future<void> updateCartItem(CartItemModel item);
  Future<void> removeCartItem(String mealId);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final DatabaseHelper dbHelper;

  CartLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final db = await dbHelper.database;
      final maps = await db.query(DatabaseHelper.tableCart);
      return maps.map((map) => CartItemModel.fromJson(map)).toList();
    } catch (e) {
      throw CacheException('Error al obtener carrito');
    }
  }

  @override
  Future<void> addCartItem(CartItemModel item) async {
    try {
      final db = await dbHelper.database;
      await db.insert(
        DatabaseHelper.tableCart,
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException('Error al agregar al carrito');
    }
  }

  @override
  Future<void> updateCartItem(CartItemModel item) async {
    try {
      final db = await dbHelper.database;
      await db.update(
        DatabaseHelper.tableCart,
        item.toJson(),
        where: 'mealId = ?',
        whereArgs: [item.mealId],
      );
    } catch (e) {
      throw CacheException('Error al actualizar carrito');
    }
  }

  @override
  Future<void> removeCartItem(String mealId) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        DatabaseHelper.tableCart,
        where: 'mealId = ?',
        whereArgs: [mealId],
      );
    } catch (e) {
      throw CacheException('Error al eliminar del carrito');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final db = await dbHelper.database;
      await db.delete(DatabaseHelper.tableCart);
    } catch (e) {
      throw CacheException('Error al limpiar carrito');
    }
  }
}