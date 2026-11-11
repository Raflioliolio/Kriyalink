import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/user_model.dart';
import '../../widgets/kreator_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/loading_shimmer.dart';

class UmkmHomeScreen extends StatefulWidget {
  const UmkmHomeScreen({super.key});

  @override
  State<UmkmHomeScreen> createState() => _UmkmHomeScreenState();
}

class _UmkmHomeScreenState extends State<UmkmHomeScreen> {
  String _selectedCategory = 'Semua';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Logo',
    'Packaging',
    'Fotografi',
    'Sosial Media',
  ];

  final List<UserModel> _dummyKreators = [
    UserModel(
      id: 'k1',
      name: 'Dian Susanti',
      role: 'kreator',
      phone: '081234567890',
      city: 'Yogyakarta',
      bio: 'Spesialis desain logo dan branding untuk UMKM lokal. 5 tahun pengalaman.',
      profileImage:
          'https://randomuser.me/api/portraits/women/44.jpg',
      skills: ['Logo', 'Packaging'],
      priceStart: 150000,
      rating: 4.9,
      jobCount: 87,
    ),
    UserModel(
      id: 'k2',
      name: 'Reza Firmansyah',
      role: 'kreator',
      phone: '081234567891',
      city: 'Bandung',
      bio: 'Fotografer produk profesional. Spesialis foto kuliner dan fashion.',
      profileImage:
          'https://randomuser.me/api/portraits/men/32.jpg',
      skills: ['Fotografi', 'Sosial Media'],
      priceStart: 200000,
      rating: 4.8,
      jobCount: 63,
    ),
    UserModel(
      id: 'k3',
      name: 'Aulia Ramadhani',
      role: 'kreator',
      phone: '081234567892',
      city: 'Jakarta',
      bio: 'Content creator dan desainer sosial media. Jadikan produkmu viral!',
      profileImage:
          'https://randomuser.me/api/portraits/women/68.jpg',
      skills: ['Sosial Media', 'Logo'],
      priceStart: 100000,
      rating: 4.7,
      jobCount: 102,
    ),
    UserModel(
      id: 'k4',
      name: 'Bagas Prasetyo',
      role: 'kreator',
      phone: '081234567893',
      city: 'Surabaya',
      bio: 'Desainer packaging makanan dan minuman. Buat produkmu tampil premium.',
      profileImage:
          'https://randomuser.me/api/portraits/men/55.jpg',
      skills: ['Packaging', 'Logo'],
      priceStart: 250000,
      rating: 4.6,
      jobCount: 45,
    ),
    UserModel(
      id: 'k5',
      name: 'Siti Nurhaliza',
      role: 'kreator',
      phone: '081234567894',
      city: 'Semarang',
      bio: 'Fotografer dan kreator konten khusus produk UMKM. Fast response!',
      profileImage:
          'https://randomuser.me/api/portraits/women/22.jpg',
      skills: ['Fotografi', 'Packaging'],
      priceStart: 125000,
      rating: 4.5,
      jobCount: 38,
    ),
  ];

  List<UserModel> get _filteredKreators {
    return _dummyKreators.where((k) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          k.skills.contains(_selectedCategory);
      final matchesSearch = _searchQuery.isEmpty ||
          k.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.skills.any((s) =>
              s.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredKreators;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Cari kreator, keahlian, atau kota...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Branding Banner
                  GestureDetector(
                    onTap: () {
                      // Navigate to AI tab (index 1)
                      // This would ideally update the MainShell's index
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF167D8D), Color(0xFF6C63FF)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF167D8D).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('🤖', style: TextStyle(fontSize: 36)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Branding Assistant',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Buat branding produkmu dengan AI! ✨',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

                  const SizedBox(height: 20),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories
                          .map(
                            (cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CategoryChip(
                                label: cat,
                                isSelected: _selectedCategory == cat,
                                onTap: () =>
                                    setState(() => _selectedCategory = cat),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // Section header
                  Row(
                    children: [
                      Text(
                        'Kreator Tersedia 🎨',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${filtered.length} kreator',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Kreator Grid
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada kreator ditemukan',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final kreator = filtered[index];
                    return KreatorCard(
                      kreator: kreator,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/kreator-detail',
                        arguments: kreator,
                      ),
                    ).animate(
                      delay: Duration(milliseconds: 60 * index),
                    );
                  },
                  childCount: filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
              ),
            ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}
