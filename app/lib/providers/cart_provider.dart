import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);
  int get uniqueCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.subtotal);

  void add(Product product) {
    final existing = _items.where((i) => i.product.id == product.id).firstOrNull;
    if (existing != null) {
      if (existing.quantity < product.stock) existing.quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    if (item.quantity < item.product.stock) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere((i) => i.product.id == item.product.id);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.removeWhere((i) => i.product.id == item.product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int quantityOf(String productId) =>
      _items.where((i) => i.product.id == productId).firstOrNull?.quantity ?? 0;
}