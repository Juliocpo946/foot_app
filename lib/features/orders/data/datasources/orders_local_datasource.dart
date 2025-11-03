import '../../../../core/database/database_helper.dart';
import '../../../../core/error/exceptions.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

abstract class OrdersLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  final DatabaseHelper dbHelper;

  OrdersLocalDataSourceImpl({required this.dbHelper});

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final db = await dbHelper.database;
      final orderMaps = await db.query(
        DatabaseHelper.tableOrders,
        orderBy: 'timestamp DESC',
      );

      List<OrderModel> orders = [];
      for (var orderMap in orderMaps) {
        final itemMaps = await db.query(
          DatabaseHelper.tableOrderItems,
          where: 'orderId = ?',
          whereArgs: [orderMap['id']],
        );

        final items = itemMaps.map((map) => OrderItemModel.fromJson(map)).toList();
        orders.add(OrderModel.fromJson(orderMap, items));
      }

      return orders;
    } catch (e) {
      throw CacheException('Error al obtener órdenes');
    }
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    try {
      final db = await dbHelper.database;

      await db.transaction((txn) async {
        await txn.insert(
          DatabaseHelper.tableOrders,
          order.toJson(),
        );

        for (var item in order.items) {
          await txn.insert(
            DatabaseHelper.tableOrderItems,
            {
              'orderId': order.id,
              'mealId': item.mealId,
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
            },
          );
        }
      });
    } catch (e) {
      throw CacheException('Error al guardar orden');
    }
  }
}