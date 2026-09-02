import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.orders.isEmpty
          ? const _EmptyOrders()
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.dividerColor),
      ),
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
                    Text(item.product.image, style: const TextStyle(fontSize: 18)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status,
          style: const TextStyle(
              color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('No orders yet'),
          SizedBox(height: 4),
          Text('Your checkout results will appear here.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}