// class Article {
//   final List<String>? creator;
//   final String? title;
//   final String? imageUrl;
//   final List<String>? country;
//   final String? pubDate;
//   final String? content;
//   final List<String>? category;

//   const Article({
//     this.creator,
//     this.title,
//     this.imageUrl,
//     this.country,
//     this.pubDate,
//     this.content,
//     this.category,
//   });

//   factory Article.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//         'creator': List creator?,
//         'title': String? title,
//         'image_url': String? imageUrl,
//         'country': List country?,
//         'pubDate': String? pubDate,
//         'content': String? content,
//         'category': List category?,
//       } =>
//         Article(
//           creator: creator.map((e) => e.toString()).toList(),
//           title: title,
//           imageUrl: imageUrl,
//           country: country.map((e) => e.toString()).toList(),
//           pubDate: pubDate,
//           content: content,
//           category: category.map((e) => e.toString()).toList(),
//         ),
//       _ => throw const FormatException('Invalid article format.'),
//     };
//   }
// }
class Article {
  final List<String>? creator;
  final String? title;
  final String? imageUrl;
  final List<String>? country;
  final String? pubDate;
  final String? content;
  final List<String>? category;

  const Article({
    this.creator,
    this.title,
    this.imageUrl,
    this.country,
    this.pubDate,
    this.content,
    this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      creator: (json['creator'] as List?)?.map((e) => e.toString()).toList(),
      title: json['title'] as String?,
      imageUrl: json['image_url'] as String?,
      country: (json['country'] as List?)?.map((e) => e.toString()).toList(),
      pubDate: json['pubDate'] as String?,
      content: json['content'] as String?,
      category: (json['category'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
