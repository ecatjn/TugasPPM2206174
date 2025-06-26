// my_diginst_app/lib/Screens/bookmark_screen.dart
import 'package:flutter/material.dart';
import 'package:p9/routers/app_routers.dart'; // Sesuaikan import
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryYellow = Color(0xFFFFB62F);

  int _currentIndex = 1; // Current index for Bookmark tab
  List<Map<String, String>> _bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedArticles();
  }

  Future<void> _loadBookmarkedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkedArticlesJson = prefs.getStringList('bookmarked_articles');
    
    if (!mounted) return;

    if (bookmarkedArticlesJson != null) {
      setState(() {
        _bookmarkedArticles = bookmarkedArticlesJson.map((jsonString) =>
          jsonDecode(jsonString) as Map<String, String> // Deserialisasi kembali ke Map<String, String>
        ).toList();
      });
    }
  }

  Future<void> _removeBookmark(String articleTitle) async { // Menggunakan title karena ID tidak ada di dummy
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _bookmarkedArticles.removeWhere((article) => article['title'] == articleTitle);
    });

    final List<String> currentBookmarks = prefs.getStringList('bookmarked_articles') ?? [];
    currentBookmarks.removeWhere((itemJson) => jsonDecode(itemJson)['title'] == articleTitle);
    await prefs.setStringList('bookmarked_articles', currentBookmarks);

    final List<String> bookmarkedTitles = prefs.getStringList('bookmarked_articles_titles') ?? [];
    bookmarkedTitles.removeWhere((title) => !_bookmarkedArticles.any((article) => article['title'] == title));
    await prefs.setStringList('bookmarked_articles_titles', bookmarkedTitles);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark dihapus.')),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.bookmark);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.profile);
    }
    developer.log('Bottom Navigation Tapped from Bookmark: Index $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAEBD7),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: primaryYellow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/diginst.png', width: 40),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.menu, size: 28, color: Colors.black),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bookmark',
                  style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 24, fontFamily: 'Poppins'),
                ),
              ),
            ),
            _bookmarkedArticles.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        'Tidak ada artikel yang dibookmark.',
                        style: TextStyle(fontSize: 16, color: Colors.black54, fontFamily: 'Poppins'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _bookmarkedArticles.length,
                      itemBuilder: (context, index) {
                        final article = _bookmarkedArticles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              developer.log('Bookmarked Article tapped: ${article['title']}');
                              Navigator.pushNamed(
                                context,
                                AppRoutes.detail,
                                arguments: article,
                              ).then((_) => _loadBookmarkedArticles());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (article['image'] != null && article['image']!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset( // Image.asset untuk dummy
                                        article['image']!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image, color: Colors.grey),
                                          );
                                        },
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article['title']!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          article['date'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Selengkapnya',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: primaryPurple,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      _removeBookmark(article['title']!); // Hapus berdasarkan title dummy
                                    },
                                    child: Icon(
                                      Icons.bookmark,
                                      color: primaryPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

}