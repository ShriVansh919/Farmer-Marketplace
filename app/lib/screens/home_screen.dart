import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_grid.dart';
import '../widgets/promo_banner.dart';
import '../widgets/state_views.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  void _goToTab(int index) => setState(() => _tabIndex = index);

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: [
          _HomeTab(
            onGoToSearch: () => _goToTab(1),
            onOpenProduct: _openProduct,
          ),
          _SearchTab(onOpenProduct: _openProduct),
          CartScreen(onOrderPlaced: () => _goToTab(3)),
          const OrdersScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _goToTab,
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'),
          const NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: 'Search'),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders'),
          const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }
}

const _categories = ['All', 'Vegetables', 'Fruits', 'Grains', 'Dairy', 'Organic'];

class _HomeTab extends StatefulWidget {
  final VoidCallback onGoToSearch;
  final void Function(Product) onOpenProduct;
  const _HomeTab({required this.onGoToSearch, required this.onOpenProduct});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final products = context.watch<ProductProvider>().productsFuture;

    return Column(
      children: [
        _BrandHeader(onGoToSearch: widget.onGoToSearch),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorStateView(
                  onRetry: () => context.read<ProductProvider>().retry(),
                );
              }
              final all = snapshot.data ?? const <Product>[];
              final filtered = _selectedCategory == 'All'
                  ? all
                  : all.where((p) => p.category == _selectedCategory).toList();
              if (filtered.isEmpty) {
                return const GridEmptyView();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductProvider>().retry();
                  await context.read<ProductProvider>().productsFuture;
                },
                child: ListView(
                  padding: const EdgeInsets.only(top: 16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: PromoBanner(
                        title: 'Farm Fresh, Every Day',
                        subtitle: 'Direct from farmers — no middlemen',
                        icon: Icons.eco,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 4),
                        itemBuilder: (context, i) {
                          final label = _categories[i];
                          return CategoryChip(
                            label: label,
                            selected: label == _selectedCategory,
                            onTap: () =>
                                setState(() => _selectedCategory = label),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Featured Products',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    ProductGrid(
                      products: filtered,
                      onTap: (p) => widget.onOpenProduct(p),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchTab extends StatefulWidget {
  final void Function(Product) onOpenProduct;
  const _SearchTab({required this.onOpenProduct});

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().productsFuture;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: _searchCtrl,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorStateView(
                  onRetry: () => context.read<ProductProvider>().retry(),
                );
              }
              final all = snapshot.data ?? const <Product>[];
              final results = _query.isEmpty
                  ? all
                  : all
                      .where((p) =>
                          p.name.toLowerCase().contains(_query) ||
                          p.category.toLowerCase().contains(_query))
                      .toList();
              if (results.isEmpty) {
                return const Center(child: GridEmptyView());
              }
              return ProductGrid(
                products: results,
                onTap: (p) => widget.onOpenProduct(p),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final VoidCallback onGoToSearch;
  const _BrandHeader({required this.onGoToSearch});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.spa, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'Kisaan Bazaar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Fresh from farm to your home',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onGoToSearch,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: scheme.outline),
                  const SizedBox(width: 10),
                  Text('Search fresh produce...',
                      style: TextStyle(color: scheme.outline)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}