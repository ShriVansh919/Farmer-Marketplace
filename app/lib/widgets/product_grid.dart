import 'package:flutter/material.dart';

import '../models/product.dart';
import 'product_card.dart';
import 'state_views.dart';

int responsiveColumns(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  return 2;
}

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onTap;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onTap,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final columns = responsiveColumns(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final product = products[i];
        return ProductCard(product: product, onTap: () => onTap(product));
      },
    );
  }
}

class GridEmptyView extends StatelessWidget {
  const GridEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.search_off,
      title: 'No products found',
      subtitle: 'Try a different keyword or category.',
    );
  }
}