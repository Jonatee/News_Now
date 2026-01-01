import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:news_now/data/classes/article_class.dart';

class NewsDetailScreen extends StatefulWidget {
  final Article article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getTimeAgo(String? dateString) {
    if (dateString == null) return 'Recently';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${difference.inDays ~/ 7}w ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Image
          _buildHeroImage(),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildArticleHeader(),
                _buildArticleContent(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _showTitle
          ? const Color(0xFF181A20).withOpacity(0.95)
          : Colors.transparent,
      elevation: _showTitle ? 2 : 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(_showTitle ? 0 : 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _showTitle ? 1 : 0,
        child: Text(
          widget.article.title ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(_showTitle ? 0 : 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () {
                if (widget.article.link != null) {
                  Share.share(
                    '${widget.article.title}\n\n${widget.article.link}',
                    subject: widget.article.title,
                  );
                }
              },
            ),
          ),
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  Widget _buildHeroImage() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: false,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Hero(
              tag: widget.article.title ?? 'hero-${widget.article.hashCode}',
              child: Image.network(
                widget.article.imageUrl ??
                    'https://via.placeholder.com/800x400',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    const Color(0xFF0F1115).withOpacity(0.9),
                    const Color(0xFF0F1115),
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          if (widget.article.category != null &&
              widget.article.category!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFDC2626).withOpacity(0.3),
                ),
              ),
              child: Text(
                widget.article.category!.first.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFDC2626),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Title
          Text(
            widget.article.title ?? 'No Title',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Source and time
          Row(
            children: [
              // Source avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade800, width: 1),
                ),
                child: Center(
                  child: Text(
                    (widget.article.source ?? 'N')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.source ?? 'Unknown Source',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTimeAgo(widget.article.pubDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Bookmark button
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked
                      ? const Color(0xFFDC2626)
                      : Colors.grey.shade400,
                ),
                onPressed: () {
                  setState(() => _isBookmarked = !_isBookmarked);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBookmarked
                            ? 'Saved to bookmarks'
                            : 'Removed from bookmarks',
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF181A20),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade900, height: 1),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    // Generate sample content if none provided
    final content =
        widget.article.content ??
        widget.article.description ??
        '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.

Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
        ''';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description/Lead
          if (widget.article.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.article.description!,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: Colors.grey.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Content
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.7,
              color: Colors.grey.shade400,
              letterSpacing: 0.2,
            ),
          ),

          // Read more button
          if (widget.article.link != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: OutlinedButton.icon(
                onPressed: () {
                  // Open external link
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening: ${widget.article.link}'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF181A20),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text('Read full article'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFDC2626)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181A20),
        border: Border(
          top: BorderSide(color: Colors.grey.shade900, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              const Spacer(),
              // Share button (prominent)
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.article.link != null) {
                    Share.share(
                      '${widget.article.title}\n\n${widget.article.link}',
                      subject: widget.article.title,
                    );
                  }
                },
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
