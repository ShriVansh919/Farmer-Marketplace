import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();
    final inCart = cart.quantityOf(product.id) > 0;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Art(product: product),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.category.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(product.name,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _Rating(rating: product.rating),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₹${product.price.toStringAsFixed(0)}',
            style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _StockBadge(stock: product.stock),
              const SizedBox(width: 8),
              Text(' by ${product.farmerName}',
                  style: theme.textTheme.bodySmall),
            ],
          ),
          if (product.location.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(product.location, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          const Divider(height: 32),
          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(product.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: () {
              cart.add(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(inCart
                      ? 'Added another ${product.name}'
                      : '${product.name} added to cart'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(inCart
                ? 'Add another (${cart.quantityOf(product.id)})'
                : 'Add to cart'),
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
      ),
    );
  }
}

class _Art extends StatelessWidget {
  final Product product;
  const _Art({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: product.imageUrl.isEmpty
            ? _art(theme)
            : SizedBox.expand(
                child: DecoratedBox(
                  position: DecorationPosition.background,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                  ),
                  child: Image.asset(
                    'assets/images/${product.id}.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _art(theme),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _art(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      alignment: Alignment.center,
      child: Text(product.image, style: const TextStyle(fontSize: 96)),
    );
  }
}

class _Rating extends StatelessWidget {
  final double rating;
  const _Rating({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  final int stock;
  const _StockBadge({required this.stock});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final low = stock < 50;
    final color = low
        ? (dark ? Colors.orange.shade300 : Colors.orange.shade700)
        : (dark ? Colors.green.shade300 : Colors.green.shade700);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2, size: 14, color: color),
          const SizedBox(width: 4),
          Text('$stock in stock',
              style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}