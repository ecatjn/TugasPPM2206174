import 'package:flutter/material.dart';
import '../routers/app_routers.dart';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color primaryYellow = Color(0xFFFFB62F);
  static const Color backgroundColor = Color(0xFFFAEBD7);

  int _currentIndex = 0;
  late TabController _tabController;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  Set<String> _bookmarkedArticleTitles = {};
  
  late Future<List<NewsItem>> _newsArticlesFuture;
  final NewsController _newsController = NewsController();


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {}); // Memicu rebuild saat tab berubah
      }
    });
    _loadBookmarkedArticleTitles();
    _newsArticlesFuture = _fetchNewsFromApi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<NewsItem>> _fetchNewsFromApi() async {
    try {
      final BaseApiResponse<NewsListResponseBody> response = await _newsController.fetchNewsArticles();
      if (response.body.success) {
        return response.body.data;
      } else {
        developer.log('API responded with success: false. Message: ${response.body.message}');
        throw Exception('Failed to load news: ${response.body.message}');
      }
    } catch (e) {
      developer.log('Error fetching news from API: $e');
      rethrow;
    }
  }

  Future<void> _loadBookmarkedArticleTitles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkedTitles = prefs.getStringList('bookmarked_articles_titles');
    if (!mounted) return;
    setState(() {
      _bookmarkedArticleTitles = bookmarkedTitles?.toSet() ?? {};
    });
  }

  Future<void> _toggleBookmark(NewsItem article) async {
    final prefs = await SharedPreferences.getInstance();
    final String articleTitle = article.title;
    final String articleJson = jsonEncode(article.toJson());

    if (_bookmarkedArticleTitles.contains(articleTitle)) {
      _bookmarkedArticleTitles.remove(articleTitle);
      final List<String> currentBookmarks = prefs.getStringList('bookmarked_articles') ?? [];
      currentBookmarks.removeWhere((itemJson) => jsonDecode(itemJson)['title'] == articleTitle);
      await prefs.setStringList('bookmarked_articles', currentBookmarks);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark dihapus.')),
      );
    } else {
      _bookmarkedArticleTitles.add(articleTitle);
      final List<String> currentBookmarks = prefs.getStringList('bookmarked_articles') ?? [];
      currentBookmarks.add(articleJson);
      await prefs.setStringList('bookmarked_articles', currentBookmarks);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark ditambahkan.')),
      );
    }
    await prefs.setStringList('bookmarked_articles_titles', _bookmarkedArticleTitles.toList());
    if (!mounted) return;
    setState(() {});
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
    developer.log('Bottom Navigation Tapped from Home: Index $index');
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  Widget _buildArticleList(String tabType, List<NewsItem> articles) {
    final List<NewsItem> searchFilteredArticles = articles.where((article) {
      if (_searchQuery.isEmpty) {
        return true;
      }
      return article.title.toLowerCase().contains(_searchQuery) ||
             (article.summary?.toLowerCase() ?? '').contains(_searchQuery) ||
             (article.content?.toLowerCase() ?? '').contains(_searchQuery);
    }).toList();

    final List<NewsItem> finalFilteredArticles = searchFilteredArticles.where((article) {
      if (tabType == 'All') {
        return true;
      }
      return (article.category?.toLowerCase() ?? '') == tabType.toLowerCase();
    }).toList();

    if (finalFilteredArticles.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada berita ditemukan untuk kategori ini atau dengan pencarian Anda.',
          style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: finalFilteredArticles.length,
      itemBuilder: (context, index) {
        final article = finalFilteredArticles[index];
        bool isBookmarked = _bookmarkedArticleTitles.contains(article.title);

        if (index == 0 && tabType == 'Latest' && _searchQuery.isEmpty) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    developer.log('Hero Article Tapped: ${article.title}');
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: article.toJson(),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            article.featuredImageUrl!,
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
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () {
              developer.log('Article tapped: ${article.title}');
              Navigator.pushNamed(
                context,
                AppRoutes.detail,
                arguments: article.toJson(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        article.featuredImageUrl!,
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
                          article.title,
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
                          article.publishedAt.toLocal().toIso8601String().substring(0, 10),
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
                      _toggleBookmark(article);
                    },
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? primaryPurple : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
         child: Column(
            children: [
             // Header: Logo, Search Bar, Menu Icon
             Container(
              color: primaryYellow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset('assets/diginst.png', width: 40, height: 40),
                  const SizedBox(width: 12),
                  Expanded(
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _updateSearchQuery,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                       ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.menu, size: 28, color: Colors.black),
                ],
              ),
            ),

            // Tabs: Latest News, Popular News, All News
            Container(
              color: primaryYellow,
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryPurple,
                labelColor: primaryPurple,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
                tabs: const [
                  Tab(text: 'Latest News'),
                  Tab(text: 'Popular News'),
                  Tab(text: 'All News'),
                ],
              ),
            ),

            // Konten Tab (Expanded agar mengisi sisa ruang)
            Expanded(
            child: FutureBuilder<List<NewsItem>>(
                future: _newsArticlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: primaryPurple));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 50),
                            const SizedBox(height: 10),
                            Text(
                              'Gagal memuat berita: ${snapshot.error}',
                            textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _newsArticlesFuture = _fetchNewsFromApi(); // Coba muat ulang
                                });
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryPurple),
                              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada berita ditemukan.',
                        style: TextStyle(fontSize: 18, fontFamily: 'Poppins', color: Colors.black54),
                      ),
                    );
                  } else {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildArticleList('Latest', snapshot.data!),
                        _buildArticleList('Popular', snapshot.data!),
                        _buildArticleList('All', snapshot.data!),
                      ],
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryPurple,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}