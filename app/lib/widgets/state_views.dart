import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.outline),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorStateView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.cloud_off_outlined,
      title: 'Could not load products',
      subtitle: 'Something went wrong while loading the catalogue.',
      action: FilledButton.tonal(
        onPressed: onRetry,
        child: const Text('Retry'),
      ),
    );
  }
}