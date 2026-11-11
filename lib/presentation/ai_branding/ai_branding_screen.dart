import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loading_shimmer.dart';
import '../../services/ai_branding_service.dart';

// --- Provider ---

class BrandingResult {
  final List<String> brandNames;
  final String tagline;
  final String productDescription;
  final List<Color> colorPalette;
  final String brandStory;
  final String packagingTips;

  const BrandingResult({
    required this.brandNames,
    required this.tagline,
    required this.productDescription,
    required this.colorPalette,
    required this.brandStory,
    required this.packagingTips,
  });
}

class BrandingFormState {
  final String productDesc;
  final String category;
  final String target;
  final BrandingResult? result;
  final bool isLoading;
  final String? error;

  const BrandingFormState({
    this.productDesc = '',
    this.category = 'Kuliner',
    this.target = 'Umum',
    this.result,
    this.isLoading = false,
    this.error,
  });

  BrandingFormState copyWith({
    String? productDesc,
    String? category,
    String? target,
    BrandingResult? result,
    bool? isLoading,
    String? error,
  }) {
    return BrandingFormState(
      productDesc: productDesc ?? this.productDesc,
      category: category ?? this.category,
      target: target ?? this.target,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BrandingNotifier extends StateNotifier<BrandingFormState> {
  BrandingNotifier() : super(const BrandingFormState());

  void updateProductDesc(String v) => state = state.copyWith(productDesc: v);
  void updateCategory(String v) => state = state.copyWith(category: v);
  void updateTarget(String v) => state = state.copyWith(target: v);

  Future<void> generate() async {
    if (state.productDesc.trim().isEmpty) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Real Gemini API call via AiBrandingService
      final output = await aiBrandingService.generateBranding(
        productDescription: state.productDesc.trim(),
        category: state.category,
        targetMarket: state.target,
      );
      state = state.copyWith(
        isLoading: false,
        result: BrandingResult(
          brandNames: output.brandNames,
          tagline: output.tagline,
          productDescription: output.productDescription,
          colorPalette: output.colorPalette,
          brandStory: output.brandStory,
          packagingTips: output.packagingTips.join('\n• '),
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal generate. Coba lagi!');
    }
  }

  void reset() {
    state = state.copyWith(result: null, error: null);
  }
}

final brandingProvider =
    StateNotifierProvider<BrandingNotifier, BrandingFormState>(
  (ref) => BrandingNotifier(),
);

// --- Screen ---

class AiBrandingScreen extends ConsumerStatefulWidget {
  const AiBrandingScreen({super.key});

  @override
  ConsumerState<AiBrandingScreen> createState() => _AiBrandingScreenState();
}

class _AiBrandingScreenState extends ConsumerState<AiBrandingScreen> {
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  String _buildCopyText(BrandingResult r) {
    final buf = StringBuffer();
    buf.writeln('=== HASIL AI BRANDING KRIYALINK ===\n');
    buf.writeln('📛 NAMA BRAND:');
    for (int i = 0; i < r.brandNames.length; i++) {
      buf.writeln('${i + 1}. ${r.brandNames[i]}');
    }
    buf.writeln('\n💬 TAGLINE:\n${r.tagline}');
    buf.writeln('\n📝 DESKRIPSI PRODUK:\n${r.productDescription}');
    buf.writeln('\n📖 BRAND STORY:\n${r.brandStory}');
    buf.writeln('\n📦 TIPS PACKAGING:\n${r.packagingTips}');
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(brandingProvider);
    final notifier = ref.read(brandingProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('🤖', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'AI Branding',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF167D8D), Color(0xFF6C63FF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Branding Assistant',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Ceritakan produkmu, AI akan bantu buat branding yang keren!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Product description
              TextFormField(
                controller: _descController,
                maxLines: 4,
                onChanged: notifier.updateProductDesc,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ceritakan produkmu dulu ya!' : null,
                decoration: InputDecoration(
                  labelText: 'Ceritakan produkmu...',
                  hintText:
                      'Contoh: Saya jual keripik singkong pedas manis, dibuat dari singkong lokal Jawa Tengah...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: state.category,
                onChanged: (v) => notifier.updateCategory(v!),
                decoration: InputDecoration(
                  labelText: 'Kategori Produk',
                  prefixIcon: const Icon(Icons.category_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: ['Kuliner', 'Fashion', 'Kerajinan', 'Jasa', 'Lainnya']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
              ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Target dropdown
              DropdownButtonFormField<String>(
                value: state.target,
                onChanged: (v) => notifier.updateTarget(v!),
                decoration: InputDecoration(
                  labelText: 'Target Pembeli',
                  prefixIcon: const Icon(Icons.people_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: ['Anak Muda', 'Keluarga', 'Premium', 'Umum']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Generate button
              ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          notifier.generate();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '✨ Generate Branding',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ).animate(delay: 250.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),

              // Loading shimmer
              if (state.isLoading) ...[
                const SizedBox(height: 24),
                const LoadingShimmer.list(itemCount: 4, height: 60),
              ],

              // Results
              if (state.result != null && !state.isLoading) ...[
                const SizedBox(height: 24),
                _ResultsSection(
                  result: state.result!,
                  onCopy: () {
                    Clipboard.setData(
                      ClipboardData(text: _buildCopyText(state.result!)),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Disalin ke clipboard!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onRegenerate: notifier.generate,
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  final BrandingResult result;
  final VoidCallback onCopy;
  final VoidCallback onRegenerate;

  const _ResultsSection({
    required this.result,
    required this.onCopy,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            const Text('🎯', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              'Hasil AI Branding',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 14),

        // Brand names
        _ResultCard(
          title: '📛 Nama Brand',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: result.brandNames
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${e.key + 1}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          e.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Tagline
        _ResultCard(
          title: '💬 Tagline',
          child: Text(
            '"${result.tagline}"',
            style: theme.textTheme.titleSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Description
        _ResultCard(
          title: '📝 Deskripsi Produk',
          child: Text(
            result.productDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Color palette
        _ResultCard(
          title: '🎨 Palet Warna',
          child: Row(
            children: result.colorPalette.map((color) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ).animate(delay: 250.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Brand story
        _ResultCard(
          title: '📖 Brand Story',
          child: Text(
            result.brandStory,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Packaging tips
        _ResultCard(
          title: '📦 Tips Packaging',
          child: Text(
            result.packagingTips,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.8,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ).animate(delay: 350.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 16),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onCopy,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('📋 Copy Semua',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: onRegenerate,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('🔄 Generate Ulang',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ResultCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
