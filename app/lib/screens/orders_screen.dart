import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';
import '../widgets/product_thumb.dart';
import '../widgets/state_views.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.orders.isEmpty
          ? const EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              subtitle: 'Your checkout results will appear here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _OrderCard(order: orders.orders[i]),
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date =
        DateFormat('d MMM yyyy • h:mm a').format(order.placedAt.toLocal());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('#${order.id}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(date, style: theme.textTheme.bodySmall),
            const Divider(height: 20),
            for (final item in order.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    ProductThumb(product: item.product, size: 36, radius: 8),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('${item.product.name} × ${item.quantity}',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Text('₹${item.subtotal.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            const Divider(height: 20),
            Row(
              children: [
                Text(
                  '${order.itemCount} item(s)',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Text('Total: ',
                    style: theme.textTheme.bodyMedium),
                Text('₹${order.total.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status,
          style: TextStyle(
              color: scheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}