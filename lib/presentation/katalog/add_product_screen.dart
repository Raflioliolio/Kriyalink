import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  File? _imageFile;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Sumber Gambar',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt_rounded),
                ),
                title: const Text('Kamera'),
                subtitle: const Text('Ambil foto langsung'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library_rounded),
                ),
                title: const Text('Galeri'),
                subtitle: const Text('Pilih dari galeri foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_1',
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: int.parse(_priceController.text.replaceAll('.', '')),
      imageUrl: null,
      createdAt: DateTime.now(),
    );
    if (mounted) {
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
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
              // Image picker
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _imageFile != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(_imageFile!, fit: BoxFit.cover),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: ElevatedButton.icon(
                                onPressed: _showImageSourceSheet,
                                icon: const Icon(Icons.edit_rounded, size: 16),
                                label: const Text('Ganti'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 56,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tambahkan Foto Produk',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ketuk untuk mengambil foto',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Name field
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  hintText: 'Contoh: Keripik Singkong Pedas',
                  prefixIcon: const Icon(Icons.inventory_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Nama produk wajib diisi'
                    : null,
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Description field
              TextFormField(
                controller: _descController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk',
                  hintText: 'Ceritakan tentang produkmu...',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_rounded),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Deskripsi produk wajib diisi'
                    : null,
              ).animate(delay: 150.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 14),

              // Price field
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga (Rupiah)',
                  hintText: 'Contoh: 15000',
                  prefixIcon: const Icon(Icons.payments_rounded),
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Harga wajib diisi';
                  final cleaned = v.replaceAll('.', '');
                  if (int.tryParse(cleaned) == null) return 'Harga harus berupa angka';
                  return null;
                },
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),

              const SizedBox(height: 28),

              // Save button
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Simpan Produk',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ).animate(delay: 250.ms).scale(
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
