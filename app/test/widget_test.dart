import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kisaan_bazaar/main.dart';
import 'package:kisaan_bazaar/models/product.dart';
import 'package:kisaan_bazaar/providers/cart_provider.dart';

Product _product({String id = '1', double price = 40, int stock = 100}) => Product(
      id: id,
      name: 'Fresh Tomatoes',
      price: price,
      category: 'Vegetables',
      description: 'Juicy, ripe tomatoes.',
      rating: 4.5,
      stock: stock,
      image: '🍅',
      imageUrl: '',
      farmerName: 'Ramesh Kumar',
      location: 'Nashik, Maharashtra',
    );

void main() {
  group('Product model', () {
    test('parses from the app JSON schema', () {
      final p = Product.fromJson({
        'id': '7',
        'name': 'Apples',
        'price': 180,
        'category': 'Fruits',
        'description': 'Crisp sweet apples',
        'rating': 4.6,
        'stock': 80,
        'image': '🍎',
        'imageUrl': '',
        'farmerName': 'Himachal Orchards',
        'location': 'Shimla',
      });
      expect(p.id, '7');
      expect(p.name, 'Apples');
      expect(p.price, 180);
      expect(p.category, 'Fruits');
      expect(p.rating, 4.6);
      expect(p.stock, 80);
      expect(p.farmerName, 'Himachal Orchards');
    });

    test('tolerates missing optional fields', () {
      final p = Product.fromJson({'id': '1', 'name': 'X', 'price': 5});
      expect(p.description, '');
      expect(p.location, '');
    });
  });

  group('Product JSON asset', () {
    test('has the full catalog spanning all categories', () async {
      final raw = await rootBundle
          .loadString('assets/json/products.json');
      final list = jsonDecode(raw) as List<dynamic>;
      final categories =
          list.map((e) => (e as Map<String, dynamic>)['category']).toSet();
      expect(
        categories,
        {'Vegetables', 'Fruits', 'Grains', 'Dairy', 'Organic'},
      );
    });
  });

  group('CartProvider', () {
    test('add, increment, decrement, remove and totals', () {
      final cart = CartProvider()
        ..add(_product())
        ..add(_product());
      expect(cart.itemCount, 2);
      expect(cart.uniqueCount, 1);
      expect(cart.subtotal, 80);

      final item = cart.items.first;
      cart.decrement(item);
      expect(cart.itemCount, 1);

      cart.clear();
      expect(cart.isEmpty, true);
    });

    test('respects stock limit', () {
      final cart = CartProvider()
        ..add(_product(stock: 1))
        ..add(_product(stock: 1));
      expect(cart.quantityOf('1'), 1);
    });

    test('remove drops the item entirely', () {
      final cart = CartProvider()..add(_product());
      cart.remove(cart.items.first);
      expect(cart.isEmpty, true);
    });
  });

  testWidgets('splash shows brand', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const KisaanBazaarApp());
    await tester.pump();
    expect(find.text('Kisaan Bazaar'), findsOneWidget);
  });
}