import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/user_model.dart';
import '../../models/request_model.dart';
import '../../widgets/request_card.dart';

class KreatorHomeScreen extends StatelessWidget {
  const KreatorHomeScreen({super.key});

  List<ServiceRequest> get _dummyRequests => [
        ServiceRequest(
          id: 'req_1',
          umkmId: 'umkm_1',
          kreatorId: 'kreator_1',
          serviceType: 'logo',
          description:
              'Butuh desain logo untuk warung bakso saya. Nuansa merah dan putih, kesan tradisional tapi modern.',
          budgetRange: 'Rp 100-200rb',
          deadline: DateTime.now().add(const Duration(days: 14)),
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ServiceRequest(
          id: 'req_2',
          umkmId: 'umkm_2',
          kreatorId: 'kreator_1',
          serviceType: 'packaging',
          description:
              'Desain packaging untuk produk keripik singkong. Target market anak muda. Warna cerah dan playful.',
          budgetRange: 'Rp 200-500rb',
          deadline: DateTime.now().add(const Duration(days: 7)),
          status: 'accepted',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ServiceRequest(
          id: 'req_3',
          umkmId: 'umkm_3',
          kreatorId: 'kreator_1',
          serviceType: 'sosmed',
          description:
              'Butuh konten sosial media untuk promosi tahu goreng. 10 template Instagram.',
          budgetRange: '< Rp 100rb',
          deadline: DateTime.now().add(const Duration(days: 5)),
          status: 'done',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

  final Map<String, String> _umkmNames = const {
    'umkm_1': 'Bakso Pak Jono',
    'umkm_2': 'Keripik Bu Sari',
    'umkm_3': 'Tahu Goreng Pak Dedi',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requests = _dummyRequests;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🎨', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'KriyaLink',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: requests.isEmpty
          ? _buildEmptyState(context, theme)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                const Color(0xFF6C63FF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, Kreator! 👋',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${requests.length} request menunggumu hari ini',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

                        const SizedBox(height: 24),

                        Text(
                          'Request Masuk 📬',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final req = requests[index];
                        return RequestCard(
                          request: req,
                          umkmName: _umkmNames[req.umkmId] ?? 'UMKM',
                        ).animate(delay: Duration(milliseconds: 100 * index))
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: 0.05, end: 0);
                      },
                      childCount: requests.length,
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 80))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'Belum ada request masuk',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 8),
          Text(
            'Request dari UMKM akan muncul di sini',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
