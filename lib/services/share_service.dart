import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product_model.dart';
import '../core/utils.dart';

class ShareService {
  /// Open WhatsApp with pre-filled message to a kreator
  Future<void> openWhatsApp({
    required String phone,
    String? message,
  }) async {
    // Normalize phone: remove leading 0, add country code
    String normalized = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (normalized.startsWith('0')) {
      normalized = '62${normalized.substring(1)}';
    } else if (!normalized.startsWith('62')) {
      normalized = '62$normalized';
    }

    final text = Uri.encodeComponent(
      message ?? 'Halo, saya menemukan profil Anda di KriyaLink dan tertarik untuk berkolaborasi. Apakah Anda tersedia?',
    );

    final uri = Uri.parse('https://wa.me/$normalized?text=$text');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: open wa.me in browser
      await launchUrl(
        Uri.parse('https://wa.me/$normalized'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  /// Share catalog as text via system share sheet
  Future<void> shareCatalog({
    required String businessName,
    required List<ProductModel> products,
    String? catalogLink,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('🛍️ *Katalog ${businessName}*');
    buffer.writeln('');

    for (final p in products) {
      buffer.writeln('📦 *${p.name}*');
      buffer.writeln('💰 ${formatRupiah(p.price)}');
      if (p.description.isNotEmpty) {
        buffer.writeln('📝 ${p.description}');
      }
      buffer.writeln('');
    }

    buffer.writeln('---');
    buffer.writeln('Dipesan melalui KriyaLink 🎨');
    if (catalogLink != null) {
      buffer.writeln('Link katalog: $catalogLink');
    }

    await Share.share(
      buffer.toString(),
      subject: 'Katalog ${businessName} - KriyaLink',
    );
  }

  /// Copy text to clipboard and show snackbar (call from widget)
  String buildCatalogText({
    required String businessName,
    required List<ProductModel> products,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Katalog $businessName');
    for (final p in products) {
      buffer.writeln('- ${p.name}: ${formatRupiah(p.price)}');
    }
    return buffer.toString();
  }
}

final shareService = ShareService();
