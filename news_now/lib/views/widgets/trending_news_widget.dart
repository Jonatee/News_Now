import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingNewsContainerPage extends StatefulWidget {
  final String title;
  final String category;
  final String imageUrl;
  final String pubDate;
  const TrendingNewsContainerPage({
    super.key,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.pubDate,
  });

  @override
  State<TrendingNewsContainerPage> createState() =>
      _TrendingNewsContainerPageState();
}

class _TrendingNewsContainerPageState extends State<TrendingNewsContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: BoxBorder.all(color: Colors.black, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                widget.imageUrl,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      widget.category,
                      style: GoogleFonts.interTight(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      widget.title,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.comicNeue(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
