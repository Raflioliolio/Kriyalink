import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../models/request_model.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  String _serviceType = 'logo';
  String _budgetRange = '< Rp 100rb';
  DateTime? _deadline;
  File? _referenceImage;
  bool _isSending = false;

  final Map<String, String> _serviceTypes = {
    'logo': 'Desain Logo',
    'packaging': 'Desain Packaging',
    'foto': 'Fotografi Produk',
    'sosmed': 'Konten Sosmed',
  };

  final List<String> _budgetRanges = [
    '< Rp 100rb',
    'Rp 100-200rb',
    'Rp 200-500rb',
    '> Rp 500rb',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickReferenceImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFrom(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFrom(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFrom(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      setState(() => _referenceImage = File(picked.path));
    }
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Pilih Deadline',
      confirmText: 'Pilih',
      cancelText: 'Batal',
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _sendRequest(UserModel kreator) async {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih deadline terlebih dahulu'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Request berhasil dikirim ke ${kreator.name}!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kreator = ModalRoute.of(context)!.settings.arguments as UserModel;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Kirim Request',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
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
              // Kreator info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        kreator.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Untuk:',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(0.6),
                          ),
                        ),
                        Text(
                          kreator.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '📍 ${kreator.city}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Service type
              DropdownButtonFormField<String>(
                value: _serviceType,
                onChanged: (v) => setState(() => _serviceType = v!),
                decoration: InputDecoration(
                  labelText: 'Jenis Layanan',
                  prefixIcon: const Icon(Icons.design_services_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _serviceTypes.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Kebutuhan',
                  hintText:
                      'Ceritakan kebutuhanmu secara detail, contoh: warna yang diinginkan, gaya desain, referensi...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Deskripsi kebutuhan wajib diisi'
                    : null,
              ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Budget range
              DropdownButtonFormField<String>(
                value: _budgetRange,
                onChanged: (v) => setState(() => _budgetRange = v!),
                decoration: InputDecoration(
                  labelText: 'Budget',
                  prefixIcon: const Icon(Icons.payments_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: _budgetRanges
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Deadline picker
              GestureDetector(
                onTap: _pickDeadline,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _deadline != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: _deadline != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deadline',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _deadline != null
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                              ),
                            ),
                            Text(
                              _deadline != null
                                  ? _formatDate(_deadline!)
                                  : 'Pilih tanggal deadline',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _deadline != null
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 250.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Reference image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gambar Referensi (Opsional)',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_referenceImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _referenceImage!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _referenceImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _pickReferenceImage,
                      icon: const Icon(Icons.add_photo_alternate_rounded),
                      label: const Text('Tambah Gambar Referensi'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 28),

              // Send button
              ElevatedButton(
                onPressed: _isSending ? null : () => _sendRequest(kreator),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '✅ Kirim Request',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ).animate(delay: 350.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
