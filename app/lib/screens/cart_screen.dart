import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/product_thumb.dart';
import '../widgets/state_views.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onOrderPlaced;
  const CartScreen({super.key, required this.onOrderPlaced});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orders = context.read<OrdersProvider>();

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Cart')),
        body: const EmptyStateView(
          icon: Icons.remove_shopping_cart_outlined,
          title: 'Your cart is empty',
          subtitle: 'Browse products and add items to your cart.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _CartItemTile(item: cart.items[i]),
            ),
          ),
          _SummaryBar(
            subtotal: cart.subtotal,
            onCheckout: () => _checkout(context, cart, orders),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout(BuildContext context, CartProvider cart,
      OrdersProvider orders) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Place order?'),
        content: Text(
            '${cart.itemCount} item(s)\nTotal: ₹${cart.subtotal.toStringAsFixed(0)}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Place order')),
        ],
      ),
    );
    if (confirmed != true) return;
    await orders.placeOrder(cart.items);
    cart.clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
    onOrderPlaced();
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.read<CartProvider>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ProductThumb(product: item.product, size: 56, radius: 10),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    '₹${(item.product.price * item.quantity).toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            _QuantityControl(item: item, cart: cart),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => cart.remove(item),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final CartItem item;
  final CartProvider cart;
  const _QuantityControl({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => cart.decrement(item),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('${item.quantity}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => cart.increment(item),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _SummaryBar extends StatelessWidget {
  final double subtotal;
  final VoidCallback onCheckout;
  const _SummaryBar({required this.subtotal, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline)),
                  Text(
                    '₹${subtotal.toStringAsFixed(0)}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Checkout'),
              style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}