import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';
import '../../models/portfolio_model.dart';

class KreatorDetailScreen extends StatelessWidget {
  const KreatorDetailScreen({super.key});

  String _formatRupiah(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  Future<void> _openWhatsApp(String phone, String name) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final intlPhone = cleanPhone.startsWith('0')
        ? '62${cleanPhone.substring(1)}'
        : cleanPhone;
    final message = Uri.encodeComponent(
      'Halo $name, saya tertarik dengan layanan kamu di KriyaLink 😊',
    );
    final url = Uri.parse('https://wa.me/$intlPhone?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  List<PortfolioItem> get _dummyPortfolio => [
        PortfolioItem(
          id: 'p1',
          kreatorId: 'k1',
          title: 'Logo Bakso Mantap',
          imageUrl: 'https://picsum.photos/seed/logo1/300/300',
          category: 'Logo',
        ),
        PortfolioItem(
          id: 'p2',
          kreatorId: 'k1',
          title: 'Packaging Keripik',
          imageUrl: 'https://picsum.photos/seed/pkg1/300/300',
          category: 'Packaging',
        ),
        PortfolioItem(
          id: 'p3',
          kreatorId: 'k1',
          title: 'Konten IG Tahu',
          imageUrl: 'https://picsum.photos/seed/sosmed1/300/300',
          category: 'Sosial Media',
        ),
        PortfolioItem(
          id: 'p4',
          kreatorId: 'k1',
          title: 'Logo Warung Nasi',
          imageUrl: 'https://picsum.photos/seed/logo2/300/300',
          category: 'Logo',
        ),
        PortfolioItem(
          id: 'p5',
          kreatorId: 'k1',
          title: 'Foto Produk Kue',
          imageUrl: 'https://picsum.photos/seed/foto1/300/300',
          category: 'Fotografi',
        ),
        PortfolioItem(
          id: 'p6',
          kreatorId: 'k1',
          title: 'Desain Label Madu',
          imageUrl: 'https://picsum.photos/seed/label1/300/300',
          category: 'Packaging',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final kreator = ModalRoute.of(context)!.settings.arguments as UserModel;
    final theme = Theme.of(context);
    final portfolio = _dummyPortfolio;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with profile header
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            foregroundColor: theme.colorScheme.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF167D8D), Color(0xFF4A5AAB)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile image
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundImage: kreator.profileImage != null
                              ? CachedNetworkImageProvider(kreator.profileImage!)
                              : null,
                          backgroundColor:
                              const Color(0xFF167D8D).withOpacity(0.3),
                          child: kreator.profileImage == null
                              ? Text(
                                  kreator.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ).animate().scale(duration: 400.ms),
                      const SizedBox(height: 10),
                      Text(
                        kreator.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Colors.white70, size: 14),
                          Text(
                            kreator.city,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.star_rounded,
                        iconColor: Colors.amber,
                        label: 'Rating',
                        value: kreator.rating.toStringAsFixed(1),
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.work_rounded,
                        iconColor: theme.colorScheme.primary,
                        label: 'Pekerjaan',
                        value: '${kreator.jobCount}',
                      ),
                      const SizedBox(width: 12),
                      _StatCard(
                        icon: Icons.attach_money_rounded,
                        iconColor: Colors.green,
                        label: 'Mulai dari',
                        value: _formatRupiah(kreator.priceStart),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // Skills
                  Text(
                    'Keahlian',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: kreator.skills
                        .map(
                          (skill) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              skill,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // Bio
                  Text(
                    'Tentang',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    kreator.bio,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.6,
                    ),
                  ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 24),

                  // Portfolio
                  Text(
                    'Portofolio 🖼️',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: portfolio.length,
                    itemBuilder: (context, i) {
                      final item = portfolio[i];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: theme.colorScheme.surfaceVariant,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceVariant,
                            child: Icon(Icons.image_rounded,
                                color: theme.colorScheme.outline),
                          ),
                        ),
                      ).animate(delay: Duration(milliseconds: 50 * i))
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
                    },
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Action buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/request-form',
                  arguments: kreator,
                ),
                icon: const Text('📝'),
                label: const Text('Kirim Request'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _openWhatsApp(kreator.phone, kreator.name),
                icon: const Text('💬'),
                label: const Text('WhatsApp'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF25D366), width: 1.5),
                  foregroundColor: const Color(0xFF25D366),
                ),
              ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
