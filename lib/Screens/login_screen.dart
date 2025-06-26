// lib/Screens/add_news_screen.dart
import 'package:flutter/material.dart';
import 'package:p9/routers/app_routers.dart'; // Sesuaikan import jika nama proyek beda
import 'dart:developer' as developer;

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key});

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk form
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  DateTime? _selectedDate; 

  // static const Color primaryPurple = Color(0xFF6A1B9A); // Warna sudah global
  // static const Color primaryYellow = Color(0xFFFFB62F);
  // static const Color backgroundColor = Color(0xFFFAEBD7); // Warna sudah global
  // static const Color cardColor = Color(0xFFFFD89C); // Warna sudah global

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'Poppins'),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: (maxLines > 1 ? 12 : 14), horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna dari scope MyApp (main.dart theme)
    final primaryPurple = Theme.of(context).primaryColor;
    final primaryYellow = const Color(0xFFFFB62F); // Warna ini masih spesifik
    final backgroundColor = const Color(0xFFFAEBD7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryYellow,
        elevation: 0,
        title: const Text(
          'Tambah Berita Baru',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                labelText: 'Judul Berita',
                validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _summaryController,
                labelText: 'Ringkasan',
                maxLines: 3,
                validator: (value) => value == null || value.isEmpty ? 'Ringkasan tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _contentController,
                labelText: 'Isi Berita Lengkap',
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                validator: (value) => value == null || value.isEmpty ? 'Isi berita tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _imageUrlController,
                labelText: 'URL Gambar Utama',
                hintText: 'https://example.com/image.jpg',
                keyboardType: TextInputType.url,
                validator: (value) => value == null || value.isEmpty ? 'URL gambar tidak boleh kosong' : null,
              ),
              _buildTextField(
                controller: _categoryController,
                labelText: 'Kategori',
                hintText: 'Misal: Teknologi, Sains',
                validator: (value) => value == null || value.isEmpty ? 'Kategori tidak boleh kosong' : null,
              ),
              // Input Tanggal Terbit
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Terbit',
                      labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black54),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      suffixIcon: Icon(Icons.calendar_today, color: primaryPurple),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Pilih Tanggal'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tanggal terbit harus dipilih.')),
                          );
                          return;
                        }

                        developer.log('Form is valid! Attempting to add news (simulated)...');

                        // Data dummy untuk dikirim (simulasi API call)
                        final Map<String, dynamic> newsData = {
                          "title": _titleController.text,
                          "summary": _summaryController.text,
                          "content": _contentController.text,
                          "featured_image_url": _imageUrlController.text,
                          "category": _categoryController.text,
                          "published_at": _selectedDate!.toIso8601String(),
                          "tags": ["Flutter", "UI"], // Dummy tags
                        };

                        developer.log('Simulating sending data: ${newsData}');

                        // Simulasikan sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berita berhasil ditambahkan (simulasi)!')),
                        );
                        // Kosongkan form setelah sukses simulasi
                        _titleController.clear();
                        _summaryController.clear();
                        _contentController.clear();
                        _imageUrlController.clear();
                        _categoryController.clear();
                        setState(() {
                          _selectedDate = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Terbitkan Berita',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}