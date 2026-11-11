import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class BrandingOutput {
  final List<String> brandNames;
  final String tagline;
  final String productDescription;
  final String brandStory;
  final List<Color> colorPalette;
  final List<String> packagingTips;

  const BrandingOutput({
    required this.brandNames,
    required this.tagline,
    required this.productDescription,
    required this.brandStory,
    required this.colorPalette,
    required this.packagingTips,
  });

  factory BrandingOutput.fromJson(Map<String, dynamic> json) {
    // Parse color hex strings to Color
    List<Color> colors = [];
    final palette = json['color_palette'] as Map<String, dynamic>? ?? {};
    for (final key in ['primary', 'secondary', 'accent']) {
      final hex = (palette[key] as String? ?? '#167D8D').replaceAll('#', '');
      try {
        colors.add(Color(int.parse('FF$hex', radix: 16)));
      } catch (_) {
        colors.add(const Color(0xFF167D8D));
      }
    }
    // Add neutral & dark
    colors.add(const Color(0xFFF8F3E3));
    colors.add(const Color(0xFF1A1A2E));

    return BrandingOutput(
      brandNames: List<String>.from(json['brand_names'] ?? []),
      tagline: json['tagline'] as String? ?? '',
      productDescription: json['product_description'] as String? ?? '',
      brandStory: json['brand_story'] as String? ?? '',
      colorPalette: colors,
      packagingTips: List<String>.from(json['packaging_tips'] ?? []),
    );
  }

  /// Fallback when AI is unavailable or parsing fails
  factory BrandingOutput.fallback(String productDesc, String category) {
    return BrandingOutput(
      brandNames: [
        'Nusantara $category',
        '$category Prima',
        'Rasa Asli $category',
        'Karya Lokal $category',
        'Heritage $category',
      ],
      tagline: 'Autentik, Berkualitas, Kebangaan Lokal',
      productDescription:
          '$productDesc yang dibuat dengan bahan pilihan lokal, menghadirkan cita rasa autentik dengan kualitas premium untuk masyarakat Indonesia.',
      brandStory:
          'Bermula dari kecintaan terhadap produk lokal Indonesia, kami hadir mengangkat potensi UMKM ke level berikutnya. Setiap produk mengandung nilai tradisi yang berpadu dengan inovasi modern.',
      colorPalette: const [
        Color(0xFF167D8D),
        Color(0xFFE8A838),
        Color(0xFF2D6A4F),
        Color(0xFFF8F3E3),
        Color(0xFF5C4033),
      ],
      packagingTips: [
        'Gunakan warna hangat (oranye/cokelat) untuk kesan tradisional & premium',
        'Tambahkan motif batik atau ukiran sebagai identitas lokal yang kuat',
        'Pilih font Serif klasik untuk headline, Sans-serif untuk body text',
        'Material kraft paper memberikan kesan eco-friendly yang disukai konsumen',
        'Tambahkan label "Produk UMKM Lokal" sebagai nilai tambah kepercayaan',
      ],
    );
  }
}

class AiBrandingService {
  late final GenerativeModel _model;
  bool _initialized = false;

  AiBrandingService() {
    _init();
  }

  void _init() {
    try {
      if (kGeminiApiKey.isNotEmpty && kGeminiApiKey != 'YOUR_GEMINI_API_KEY') {
        _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: kGeminiApiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.8,
            maxOutputTokens: 1024,
          ),
        );
        _initialized = true;
      }
    } catch (_) {
      _initialized = false;
    }
  }

  Future<BrandingOutput> generateBranding({
    required String productDescription,
    required String category,
    required String targetMarket,
  }) async {
    // If not initialized (no API key), return smart fallback
    if (!_initialized) {
      await Future.delayed(const Duration(seconds: 1)); // simulate delay
      return BrandingOutput.fallback(productDescription, category);
    }

    final prompt = '''
Kamu adalah konsultan branding profesional untuk UMKM Indonesia.

Berdasarkan deskripsi produk berikut:
- Produk: $productDescription
- Kategori: $category
- Target pasar: $targetMarket

Berikan rekomendasi branding dalam format JSON valid berikut:
{
  "brand_names": ["nama brand 1", "nama brand 2", "nama brand 3"],
  "tagline": "1 tagline singkat dan memorable dalam bahasa Indonesia",
  "product_description": "deskripsi produk 2-3 kalimat menarik untuk marketplace",
  "color_palette": {
    "primary": "#HEXCODE",
    "secondary": "#HEXCODE",
    "accent": "#HEXCODE",
    "description": "penjelasan singkat kenapa warna ini cocok"
  },
  "brand_story": "cerita brand 2-3 kalimat yang emotionally engaging dalam bahasa Indonesia",
  "packaging_tips": [
    "tips packaging 1",
    "tips packaging 2",
    "tips packaging 3"
  ]
}

Gunakan bahasa Indonesia yang natural, menarik, dan sesuai target pasar.
Hanya balas dengan JSON valid, tanpa teks lain.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      // Clean up potential markdown code blocks
      final clean = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final json = jsonDecode(clean) as Map<String, dynamic>;
      return BrandingOutput.fromJson(json);
    } catch (e) {
      // Return fallback on any error
      return BrandingOutput.fallback(productDescription, category);
    }
  }
}

// Singleton instance
final aiBrandingService = AiBrandingService();
