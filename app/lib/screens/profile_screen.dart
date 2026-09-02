import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = auth.user;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 44,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(height: 16),
        Text(user?.name ?? 'User',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(user?.email ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: 32),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark theme'),
            subtitle: const Text('Switch between light and dark'),
            value: themeProvider.darkMode,
            onChanged: (_) => themeProvider.toggle(),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('Kisaan Bazaar v1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Kisaan Bazaar',
              applicationVersion: '1.0.0',
              applicationLegalese: 'JOVAC Flutter Classroom Project',
              children: const [
                Text('A digital marketplace for agricultural produce '
                    'built with Flutter, Provider and SharedPreferences.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context, auth),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthProvider auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to shop.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Logout')),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!context.mounted) return;
    final cart = context.read<CartProvider>();
    await auth.logout();
    // Cart is per-session; clear it on logout too.
    cart.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}