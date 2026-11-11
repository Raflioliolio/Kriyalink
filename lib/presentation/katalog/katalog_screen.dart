import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/product_model.dart';
import '../../widgets/product_card.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  State<KatalogScreen> createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final List<ProductModel> _products = [
    ProductModel(
      id: 'prod_1',
      userId: 'user_1',
      name: 'Keripik Singkong Pedas Manis',
      description:
          'Keripik singkong asli Jawa Tengah dengan bumbu pedas manis yang khas. Cocok untuk camilan keluarga.',
      price: 15000,
      imageUrl: 'https://picsum.photos/seed/keripik/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ProductModel(
      id: 'prod_2',
      userId: 'user_1',
      name: 'Sambal Bawang Homemade',
      description:
          'Sambal bawang goreng buatan rumah, tanpa pengawet, siap saji. Tersedia ukuran 150gr dan 300gr.',
      price: 25000,
      imageUrl: 'https://picsum.photos/seed/sambal/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ProductModel(
      id: 'prod_3',
      userId: 'user_1',
      name: 'Kue Lapis Legit Premium',
      description:
          'Lapis legit premium dengan 20 lapisan, menggunakan butter asli. Cocok untuk hampers dan hadiah.',
      price: 120000,
      imageUrl: 'https://picsum.photos/seed/lapislegit/400/300',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  Future<void> _shareKatalog() async {
    final text = StringBuffer();
    text.writeln('🛍️ Katalog Produk Kami:\n');
    for (final p in _products) {
      final price = p.price.toString();
      final buf = StringBuffer();
      for (int i = 0; i < price.length; i++) {
        if (i > 0 && (price.length - i) % 3 == 0) buf.write('.');
        buf.write(price[i]);
      }
      text.writeln('• ${p.name} - Rp ${buf.toString()}');
    }
    text.writeln('\nDibuat dengan KriyaLink 🎨');
    await Share.share(text.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Katalog Saya 📦',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareKatalog,
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Bagikan Katalog',
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: _products.isEmpty
          ? _buildEmptyState(context, theme)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Text('📦', style: TextStyle(fontSize: 32)),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_products.length} Produk',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    'dalam katalog kamu',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onPrimaryContainer
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(
                          product: _products[index],
                        ).animate(
                          delay: Duration(milliseconds: 80 * index),
                        );
                      },
                      childCount: _products.length,
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-product');
          if (result != null && result is ProductModel) {
            setState(() => _products.insert(0, result));
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ).animate(delay: 300.ms).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📦', style: TextStyle(fontSize: 80))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'Katalog masih kosong',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            'Tambahkan produk pertamamu sekarang!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add-product'),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Produk Pertama'),
          ).animate(delay: 400.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
