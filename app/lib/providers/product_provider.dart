import 'package:flutter/foundation.dart';

import '../data/product_repository.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  late Future<List<Product>> productsFuture;

  ProductProvider() {
    productsFuture = _repository.loadProducts();
  }

  void retry() {
    productsFuture = _repository.loadProducts();
    notifyListeners();
  }
}