import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String subtitle;
  const AuthHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.primaryContainer.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.spa, size: 44, color: scheme.primary),
        ),
        const SizedBox(height: 14),
        Text(
          'Kisaan Bazaar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.outline),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}