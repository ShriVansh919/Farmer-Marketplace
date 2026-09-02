import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

class OrdersProvider extends ChangeNotifier {
  static const _ordersKey = 'kb_orders';

  final List<Order> _orders = [];
  bool _loaded = false;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get loaded => _loaded;

  Future<void> loadOrders() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        _orders
          ..clear()
          ..addAll(list
              .map((e) => _orderFromJson(e as Map<String, dynamic>))
              .toList());
      } catch (_) {}
    }
    _loaded = true;
    notifyListeners();
  }

  Future<Order> placeOrder(List<CartItem> items) async {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch,
      items: items.map((i) => _snapshotItem(i)).toList(),
      total: items.fold(0.0, (sum, i) => sum + i.subtotal),
      status: 'Placed',
      placedAt: DateTime.now(),
    );
    _orders.insert(0, order);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ordersKey,
        jsonEncode(_orders.map((o) => _orderToJson(o)).toList()));
    return order;
  }

  static Order _orderFromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((e) => CartItem(
              product: Product.fromJson(e as Map<String, dynamic>),
              quantity: (e['quantity'] as num).toInt(),
            ))
        .toList();
    return Order(
      id: json['id'] as int,
      items: items,
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      placedAt: DateTime.parse(json['placedAt'] as String),
    );
  }

  static Map<String, dynamic> _orderToJson(Order o) => {
        'id': o.id,
        'items': o.items.map(_snapshotToJson).toList(),
        'total': o.total,
        'status': o.status,
        'placedAt': o.placedAt.toIso8601String(),
      };

  static CartItem _snapshotItem(CartItem item) {
    final p = item.product;
    return CartItem(
      product: Product(
        id: p.id,
        name: p.name,
        price: p.price,
        category: p.category,
        description: p.description,
        rating: p.rating,
        stock: p.stock,
        image: p.image,
        imageUrl: p.imageUrl,
        farmerName: p.farmerName,
        location: p.location,
      ),
      quantity: item.quantity,
    );
  }

  static Map<String, dynamic> _snapshotToJson(CartItem i) => i.toJson();
}