import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_now/views/pages/news_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_now/data/classes/article_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> futureArticles;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Future<List<Article>> fetchArticles({String? category, String? query}) async {
    const String cacheKey = 'cached_articles';
    const String timeKey = 'last_fetch_time';
    final prefs = await SharedPreferences.getInstance();

    final isMainFeed =
        (category == 'All' || category == null) &&
        (query == null || query.isEmpty);

    if (isMainFeed) {
      final cachedData = prefs.getString(cacheKey);
      final lastFetchTimeStr = prefs.getString(timeKey);

      if (cachedData != null &&
          cachedData.isNotEmpty &&
          lastFetchTimeStr != null) {
        try {
          final lastFetchTime = DateTime.parse(lastFetchTimeStr);
          if (DateTime.now().difference(lastFetchTime).inHours < 24) {
            final decoded = jsonDecode(cachedData) as List<dynamic>;
            return decoded.map((e) => Article.fromJson(e)).toList();
          }
        } catch (_) {}
      }
    }

    String baseUrl =
        'https://newsdata.io/api/1/latest?apikey=pub_bfd6d50bfda44ed4bab27d7c11333056';

    // Build values dynamically
    if (query != null && query.isNotEmpty) {
      baseUrl += '&q=$query';
    } else if (category != null && category != 'All') {
      String apiCategory = category.toLowerCase();
      if (apiCategory == 'tech') apiCategory = 'technology';
      baseUrl += '&category=$apiCategory';
    } else {
      // Default fallback
      baseUrl += '&q=business';
    }

    final url = Uri.parse(baseUrl);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final results = body['results'] as List<dynamic>?;
      if (results == null) return [];

      if (isMainFeed) {
        await prefs.setString(cacheKey, jsonEncode(results));
        await prefs.setString(timeKey, DateTime.now().toIso8601String());
      }
      return results.map((e) => Article.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFDC2626)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final articles = snapshot.data ?? [];

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildTopStories(articles)),
            SliverToBoxAdapter(child: _buildTrendingNews(articles)),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181A20),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            setState(() {
              futureArticles = fetchArticles(query: value);
              _selectedCategory = 'All'; // Reset category on search
            });
          },
          decoration: InputDecoration(
            hintText: 'Search for topics, locations & sources...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Color(0xFFDC2626)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      'All',
      'World',
      'Business',
      'Tech',
      'Science',
      'Health',
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = categories[index];
                  futureArticles = fetchArticles(category: _selectedCategory);
                });
              },
              backgroundColor: const Color(0xFF181A20),
              selectedColor: const Color(0xFFDC2626),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFDC2626)
                    : Colors.grey.shade800,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopStories(List<Article> articles) {
    final topStories = articles.take(3).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    color: const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Top Stories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300, // Fixed height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: topStories.length,
            itemBuilder: (context, index) {
              final article = topStories[index];
              return _buildStoryCard(article);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStoryCard(Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        width: 280, // Reduced width to prevent overflow
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF181A20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade900),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important: prevent infinite height
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Hero(
                    tag: article.title ?? 'hero-${article.hashCode}',
                    child: Image.network(
                      article.imageUrl ?? 'https://via.placeholder.com/300x200',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 160,
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.category?.first ?? 'News',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      article.title ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade800, height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    (article.source ?? 'N')[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  article.source ?? 'Unknown',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '2h ago',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingNews(List<Article> articles) {
    final trending = articles.skip(3).take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 20, color: const Color(0xFFDC2626)),
              const SizedBox(width: 8),
              const Text(
                'Trending News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...trending.map((article) => _buildTrendingItem(article)),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF181A20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade900),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Hero(
                tag: article.title ?? 'hero-${article.hashCode}',
                child: Image.network(
                  article.imageUrl ?? 'https://via.placeholder.com/100',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          article.category?.first.toUpperCase() ?? 'NEWS',
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• 1h ago',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.source ?? 'Unknown Source',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
