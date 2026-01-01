// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:news_now/data/classes/article_class.dart';
// import 'package:news_now/data/notifiers.dart';
// import 'package:news_now/views/widgets/nav_item.dart';
// import 'package:news_now/views/widgets/trending_news_widget.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

// late Future<List<Article>> futureArticles;

//   Future<List<Article>> fetchArticles() async {
//     const String cacheKey = 'cached_articles';
//     final prefs = await SharedPreferences.getInstance();

//     // Step 1: Check for cached data
//     final cachedData = prefs.getString(cacheKey);
//     if (cachedData != null && cachedData.isNotEmpty) {
//       try {
//         final decoded = jsonDecode(cachedData) as List<dynamic>;
//         return decoded.map((e) => Article.fromJson(e)).toList();
//       } catch (_) {
//         // corrupted cache, ignore and fetch fresh
//       }
//     }

//     // Step 2: Fetch from API
//     final url = Uri.parse(
//       'https://newsdata.io/api/1/latest?apikey=pub_bfd6d50bfda44ed4bab27d7c11333056&q=business',
//     );
//     final res = await http.get(url);

//     if (res.statusCode == 200) {
//       final body = jsonDecode(res.body);
//       final results = body['results'] as List<dynamic>?;

//       if (results == null) return [];

//       // Cache it
//       prefs.setString(cacheKey, jsonEncode(results));

//       // Return parsed
//       return results.map((e) => Article.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to fetch articles (${res.statusCode})');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
    
//     final categories = [
//       "All",
//       "Business",
//       "Sports",
//       "Technology",
//       "Politics",
//       "Health",
//       "Science",
//     ];

//     final newsList = List.generate(6, (index) => "Headline $index");

//     final trendingNews = List.generate(
//       10,
//       (index) => TrendingNewsContainerPage(
//         title: 'Sample Headline #$index',
//         category: 'Category $index',
//         imageUrl: 'assets/images/news.jpeg',
//         pubDate: "2025-07-${index + 1}",
//       ),
//     );

//     return Scaffold(
//       body: ValueListenableBuilder(
//         valueListenable: isDarkModeNotifier,
//         builder: (context, isDarkMode, child) {
//           return SingleChildScrollView(
//             // vertical scroll
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 80),

//                   // ===== Search bar =====
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: TextField(
//                       style: TextStyle(
//                         color: isDarkMode ? Colors.white : Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         label: const Icon(Icons.search_outlined),
//                         hintText: 'Search',
//                         hintStyle: const TextStyle(color: Colors.red),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // ===== Categories (horizontal) =====
//                   SizedBox(
//                     height: 50,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       itemBuilder: (context, index) {
//                         return NavItem(title: categories[index]);
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // ===== News cards (horizontal) =====
//                   SizedBox(
//                     height: 220,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: newsList.length,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemBuilder: (context, index) {
//                         final isDark =
//                             Theme.of(context).brightness == Brightness.dark;

//                         return Padding(
//                           padding: const EdgeInsets.only(right: 16.0),
//                           child: SizedBox(
//                             width: size.width * 0.6,
//                             child: Card(
//                               elevation: isDark ? 0 : 8,
//                               shadowColor: isDark
//                                   ? Colors.transparent
//                                   : Colors.black54,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               clipBehavior: Clip.antiAlias,
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     flex: 2,
//                                     child: Image.asset(
//                                       'assets/images/news.jpeg',
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                       color: Colors.white,
//                                       width: double.infinity,
//                                       padding: const EdgeInsets.all(12),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           FittedBox(
//                                             child: Text(
//                                               "This is a short description of the news item",
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 color: Colors.black87,
//                                                 fontSize: 20,
//                                                 height: 1.1,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   const SizedBox(height: 15),
//                   const Divider(),

//                   // ===== Trending Section =====
//                   Text(
//                     "Trending News",
//                     style: GoogleFonts.bebasNeue(
//                       fontSize: 28,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const Divider(),
//                   const SizedBox(height: 20),

//                   // ===== Trending news cards (vertical) =====
//                   Column(
//                     children: List.generate(trendingNews.length, (index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: trendingNews[index],
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_now/data/classes/article_class.dart';
import 'package:news_now/data/notifiers.dart';
import 'package:news_now/views/widgets/nav_item.dart';
import 'package:news_now/views/widgets/trending_news_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  // ===========================
  // FETCH + CACHE NEWS DATA
  // ===========================
  Future<List<Article>> fetchArticles() async {
    const String cacheKey = 'cached_articles';
    final prefs = await SharedPreferences.getInstance();

    // --- Step 1: Try cached data first ---
    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null && cachedData.isNotEmpty) {
      try {
        final decoded = jsonDecode(cachedData) as List<dynamic>;
        return decoded.map((e) => Article.fromJson(e)).toList();
      } catch (_) {
        // corrupted cache, ignore
      }
    }

    // --- Step 2: Fetch fresh data from API ---
    final url = Uri.parse(
      'https://newsdata.io/api/1/latest?apikey=pub_bfd6d50bfda44ed4bab27d7c11333056&q=business',
    );
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final results = body['results'] as List<dynamic>?;

      if (results == null) return [];

      // Cache it locally
      await prefs.setString(cacheKey, jsonEncode(results));

      return results.map((e) => Article.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch articles (${res.statusCode})');
    }
  }

  // ===========================
  // MAIN UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categories = [
      "All",
      "Business",
      "Sports",
      "Technology",
      "Politics",
      "Health",
      "Science",
    ];

    final newsList = List.generate(6, (index) => "Headline $index");

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, isDarkMode, child) {
          return FutureBuilder<List<Article>>(
            future: futureArticles,
            builder: (context, snapshot) {
              // --- Loading state ---
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // --- Error state ---
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }

              // --- Loaded data ---
              final articles = snapshot.data ?? [];

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),

                      // ===== Search bar =====
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            label: const Icon(Icons.search_outlined),
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),

                      // ===== Categories =====
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            return NavItem(title: categories[index]);
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ===== News Cards (horizontal) =====
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newsList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SizedBox(
                                width: size.width * 0.6,
                                child: Card(
                                  elevation: isDark ? 0 : 8,
                                  shadowColor: isDark
                                      ? Colors.transparent
                                      : Colors.black54,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image.asset(
                                          'assets/images/news.jpeg',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                child: Text(
                                                  "This is a short description of the news item",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                    height: 1.1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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

                      const SizedBox(height: 15),
                      const Divider(),

                      // ===== Trending Section =====
                      Text(
                        "Trending News",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 28,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 20),

                      // ===== Trending news cards (vertical from API) =====
                      Column(
                        children: List.generate(articles.length, (index) {
                          final a = articles[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TrendingNewsContainerPage(
                              title: a.title ?? "No Title",
                              category:
                                  a.category?.join(', ') ?? "Uncategorized",
                              imageUrl:
                                  a.imageUrl ??
                                  "https://via.placeholder.com/300x200.png?text=No+Image",
                              pubDate: a.pubDate ?? "Unknown Date",
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
