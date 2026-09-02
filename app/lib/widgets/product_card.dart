import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _productArt(theme),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productArt(ThemeData theme) {
    final url = widget.product.imageUrl;
    if (url.isEmpty) {
      return _emojiBackdrop(theme);
    }
    return SizedBox.expand(
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        ),
        child: Image.asset(
          'assets/images/${widget.product.id}.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _emojiBackdrop(theme),
        ),
      ),
    );
  }

  Widget _emojiBackdrop(ThemeData theme) {
    return Container(
      width: double.infinity,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      alignment: Alignment.center,
      child: Text(widget.product.image,
          style: const TextStyle(fontSize: 44)),
    );
  }
}