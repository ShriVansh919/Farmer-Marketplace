import 'cart_item.dart';

class Order {
  final int id;
  final List<CartItem> items;
  final double total;
  final String status;
  final DateTime placedAt;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.placedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}