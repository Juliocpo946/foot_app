import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.timestamp,
    required super.total,
    required super.status,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, List<OrderItem> items) {
    return OrderModel(
      id: json['id'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
      total: (json['total'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'total': total,
      'status': status,
    };
  }
}