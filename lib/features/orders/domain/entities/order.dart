import 'package:equatable/equatable.dart';
import 'order_item.dart';

class Order extends Equatable {
  final String id;
  final DateTime timestamp;
  final double total;
  final String status;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.timestamp,
    required this.total,
    required this.status,
    required this.items,
  });

  @override
  List<Object?> get props => [id, timestamp, total, status, items];
}