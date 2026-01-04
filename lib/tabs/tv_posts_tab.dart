import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/webview_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TVPostsTab extends StatefulWidget {
  final String profileId;
  const TVPostsTab({super.key, required this.profileId});

  @override
  State<TVPostsTab> createState() => _TVPostsTabState();
}

class _TVPostsTabState extends State<TVPostsTab> {
  List _tvPosts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTVPosts();
  }

  Future<void> _loadTVPosts() async {
    setState(() => _isLoading = true);
    try {
      final appwriteService = context.read<AppwriteService>();
      // Using generic getPosts for now, but filtering or using specific query ideal
      // In real implementation, this calls getTVPosts which queries tv_posts collection
      final posts =
          await appwriteService.getTVPosts(widget.profileId, limit: 50);
      setState(() {
        _tvPosts = posts.rows;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading TV posts: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_tvPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rss_feed, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No articles yet',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTVPosts,
      child: GridView.custom(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
            const QuiltedGridTile(1, 1),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = _tvPosts[index];
            final data = post.data;
            final imageUrl = data['image_url'];
            final title = data['title'] ?? 'No Title';
            final url = data['url'];

            return GestureDetector(
              onTap: () {
                if (url != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(url: url),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    if (imageUrl != null && imageUrl.toString().isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
                      )
                    else
                      Container(
                        color: Colors.blue.shade50,
                        child: Icon(Icons.article,
                            color: Colors.blue.shade200, size: 32),
                      ),

                    // Gradient Overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),

                    // Title
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // TV Badge (Top Right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: _tvPosts.length,
        ),
      ),
    );
  }
}
