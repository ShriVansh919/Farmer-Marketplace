import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  static const _asset = 'assets/json/products.json';

  Future<List<Product>> loadProducts() async {
    final raw = await rootBundle.loadString(_asset);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}