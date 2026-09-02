import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductThumb extends StatelessWidget {
  final Product product;
  final double size;
  final double radius;

  const ProductThumb({
    super.key,
    required this.product,
    this.size = 56,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: product.imageUrl.isEmpty
            ? _fallback(scheme)
            : DecoratedBox(
                position: DecorationPosition.background,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.4),
                ),
                child: Image.asset(
                  'assets/images/${product.id}.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _fallback(scheme),
                ),
              ),
      ),
    );
  }

  Widget _fallback(ColorScheme scheme) {
    return Container(
      color: scheme.primaryContainer.withValues(alpha: 0.4),
      alignment: Alignment.center,
      child: Text(product.image, style: TextStyle(fontSize: size * 0.55)),
    );
  }
}