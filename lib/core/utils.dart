import 'package:intl/intl.dart' show NumberFormat, DateFormat;

/// Formats an integer or double [amount] as Indonesian Rupiah.
///
/// Example: `formatRupiah(1500000)` → `"Rp 1.500.000"`
String formatRupiah(num amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}

/// Formats a [DateTime] into a human-readable Indonesian date string.
///
/// Example: `formatDate(DateTime(2026, 3, 15))` → `"15 Maret 2026"`
String formatDate(DateTime date) {
  // Month names in Bahasa Indonesia
  const months = <int, String>{
    1: 'Januari',
    2: 'Februari',
    3: 'Maret',
    4: 'April',
    5: 'Mei',
    6: 'Juni',
    7: 'Juli',
    8: 'Agustus',
    9: 'September',
    10: 'Oktober',
    11: 'November',
    12: 'Desember',
  };
  return '${date.day} ${months[date.month]} ${date.year}';
}

/// Formats a [DateTime] into a short date string: `"15 Mar 2026"`.
String formatDateShort(DateTime date) {
  const months = <int, String>{
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };
  return '${date.day} ${months[date.month]} ${date.year}';
}

/// Formats a [DateTime] into a relative time string such as "2 jam lalu".
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) return 'Baru saja';
  if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
  if (diff.inHours < 24) return '${diff.inHours} jam lalu';
  if (diff.inDays < 7) return '${diff.inDays} hari lalu';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} minggu lalu';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan lalu';
  return '${(diff.inDays / 365).floor()} tahun lalu';
}

/// Capitalizes the first letter of [text].
String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

/// Truncates [text] to [maxLength] characters, appending "..." if truncated.
String truncate(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
