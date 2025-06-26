// my_diginst_app/lib/Screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DetailScreen extends StatelessWidget {
  // FIX: Menerima Map<String, String> untuk data dummy
  final Map<String, String> article;

  const DetailScreen({super.key, required this.article});

  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryYellow = Color(0xFFFFB62F);
  static const Color backgroundColor = Color(0xFFFAEBD7);
  static const Color cardColor = Color(0xFFFFD89C);

  @override
  Widget build(BuildContext context) {
    // FIX: Ambil data dari map dummy
    final String title = article['title'] ?? 'Judul Tidak Tersedia';
    final String imageUrl = article['image'] ?? ''; // Menggunakan 'image' dari dummy
    final String sourceName = article['source'] ?? 'Sumber Tidak Diketahui';
    final String publishedAt = article['date'] ?? 'Tanggal Tidak Tersedia';
    final String category = article['category'] ?? 'Kategori Tidak Tersedia'; // Menggunakan 'category' dari dummy
    final String content = article['description'] ?? 'Konten berita tidak tersedia.';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryYellow,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  SizedBox(width: 4),
                  Text(
                    'Kembali',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Detail News',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 80),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Artikel
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset( // Menggunakan Image.asset untuk dummy
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey, size: 60),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 60),
              ),
            const SizedBox(height: 16),

            // Judul Artikel
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Publish Date, Source, Category
            Text(
              'Publish at $publishedAt',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              'Source: $sourceName',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              'Category: $category',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),

            // Konten Artikel
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Bagian Komentar Area's (Visual Saja)
            Container(
              color: primaryYellow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Row(
                children: [
                  Icon(Icons.comment, color: Colors.black, size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Comment Area's",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStaticComment('Username', 'Argowisata Gunung Mas sangat indah, udaranya sejuk, dan suasananya tenang. Cocok untuk liburan santai dan menikmati alam'),
                  _buildStaticComment('Username', 'Argowisata Gunung Mas sangat indah, udaranya sejuk, dan suasananya tenang. Cocok untuk liburan santai dan menikmati alam'),
                ],
              ),
            ),

            Container(
              color: cardColor,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'write your text here...',
                          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      developer.log('Post Your Reply clicked (visual only)');
                    },
                    child: const Icon(Icons.send, size: 28, color: primaryPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticComment(String username, String commentText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  commentText,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black87,
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