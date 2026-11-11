import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/portfolio_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _role = 'umkm';
  bool _isLoading = true;

  // Dummy user data
  final Map<String, dynamic> _umkmUser = {
    'name': 'Bu Sari Handayani',
    'phone': '081234567890',
    'city': 'Yogyakarta',
    'businessName': 'Keripik Bu Sari',
    'bio': 'Pengusaha keripik singkong asal Yogyakarta',
  };

  final Map<String, dynamic> _kreatorUser = {
    'name': 'Dian Susanti',
    'phone': '081234567891',
    'city': 'Yogyakarta',
    'skills': ['Logo', 'Packaging'],
    'bio': 'Desainer logo & branding untuk UMKM lokal. 5 tahun pengalaman.',
    'rating': 4.9,
    'jobCount': 87,
  };

  final List<PortfolioItem> _portfolio = [
    PortfolioItem(
      id: 'p1', kreatorId: 'k1', title: 'Logo Bakso Mantap',
      imageUrl: 'https://picsum.photos/seed/logo1/300/300', category: 'Logo',
    ),
    PortfolioItem(
      id: 'p2', kreatorId: 'k1', title: 'Packaging Keripik',
      imageUrl: 'https://picsum.photos/seed/pkg1/300/300', category: 'Packaging',
    ),
    PortfolioItem(
      id: 'p3', kreatorId: 'k1', title: 'Konten IG',
      imageUrl: 'https://picsum.photos/seed/sosmed1/300/300', category: 'Sosial Media',
    ),
    PortfolioItem(
      id: 'p4', kreatorId: 'k1', title: 'Logo Warung',
      imageUrl: 'https://picsum.photos/seed/logo2/300/300', category: 'Logo',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('user_role') ?? 'umkm';
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah kamu yakin ingin keluar?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/onboarding', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = _role == 'kreator' ? _kreatorUser : _umkmUser;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profil',
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded),
                tooltip: 'Keluar',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF167D8D), Color(0xFF6C63FF)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Text(
                          (user['name'] as String)[0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ).animate().scale(duration: 400.ms),
                      const SizedBox(height: 10),
                      Text(
                        user['name'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _role == 'kreator' ? '🎨 Kreator' : '🏪 Pelaku UMKM',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
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
                  // Info cards
                  _InfoCard(
                    icon: Icons.location_on_rounded,
                    label: 'Kota',
                    value: user['city'] as String,
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 10),

                  _InfoCard(
                    icon: Icons.phone_rounded,
                    label: 'Nomor WhatsApp',
                    value: user['phone'] as String,
                  ).animate(delay: 50.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 10),

                  if (_role == 'umkm' && user['businessName'] != null)
                    _InfoCard(
                      icon: Icons.store_rounded,
                      label: 'Nama Usaha',
                      value: user['businessName'] as String,
                    ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

                  if (_role == 'kreator') ...[
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            label: 'Rating',
                            value: '${user['rating']}',
                            icon: Icons.star_rounded,
                            iconColor: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatBox(
                            label: 'Pekerjaan',
                            value: '${user['jobCount']}',
                            icon: Icons.work_rounded,
                            iconColor: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
                  ],

                  const SizedBox(height: 10),

                  _InfoCard(
                    icon: Icons.info_rounded,
                    label: 'Bio',
                    value: user['bio'] as String,
                  ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

                  if (_role == 'kreator') ...[
                    const SizedBox(height: 10),
                    _InfoCard(
                      icon: Icons.palette_rounded,
                      label: 'Keahlian',
                      value: (user['skills'] as List<String>).join(', '),
                    ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

                    const SizedBox(height: 20),

                    // Portfolio section
                    Row(
                      children: [
                        Text(
                          'Portofolio Saya 🖼️',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Tambah'),
                        ),
                      ],
                    ).animate(delay: 250.ms).fadeIn(duration: 300.ms),

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
                      itemCount: _portfolio.length + 1,
                      itemBuilder: (context, i) {
                        if (i == _portfolio.length) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_rounded,
                                      color: theme.colorScheme.primary),
                                  Text(
                                    'Tambah',
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: _portfolio[i].imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ).animate(
                          delay: Duration(milliseconds: 60 * i),
                        ).fadeIn(duration: 300.ms);
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Logout button
                  OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, color: Colors.red),
                    label: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
