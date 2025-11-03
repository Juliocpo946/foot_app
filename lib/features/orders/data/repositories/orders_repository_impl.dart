import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_local_datasource.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersLocalDataSource localDataSource;

  OrdersRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createOrder(Order order) async {
    try {
      final orderModel = OrderModel(
        id: order.id,
        timestamp: order.timestamp,
        total: order.total,
        status: order.status,
        items: order.items.map((item) => OrderItemModel(
          mealId: item.mealId,
          name: item.name,
          price: item.price,
          quantity: item.quantity,
        )).toList(),
      );

      await localDataSource.saveOrder(orderModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}