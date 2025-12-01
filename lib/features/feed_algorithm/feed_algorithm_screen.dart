import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- Data Models ---
class PostStats {
  final int likes;
  final int comments;
  final int shares;

  PostStats({required this.likes, required this.comments, required this.shares});
}

class Post {
  final String title;
  final DateTime timestamp;
  final PostStats stats;
  double score;

  Post({
    required this.title,
    required this.timestamp,
    required this.stats,
    this.score = 0.0,
  });
}

// --- Algorithm ---
double calculateScore(Post post) {
  final hoursSincePosted = DateTime.now().difference(post.timestamp).inHours;
  // FinalScore = ((Likes * 1) + (Comments * 5) + (Shares * 10)) / (HoursSincePosted + 2)^1.5
  final score = ((post.stats.likes * 1) + (post.stats.comments * 5) + (post.stats.shares * 10)) /
      pow(hoursSincePosted + 2, 1.5);
  return score;
}

// --- UI ---
class FeedAlgorithmScreen extends StatefulWidget {
  const FeedAlgorithmScreen({super.key});

  @override
  FeedAlgorithmScreenState createState() => FeedAlgorithmScreenState();
}

class FeedAlgorithmScreenState extends State<FeedAlgorithmScreen> {
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _generateDummyPosts();
    _rankPosts();
  }

  List<Post> _generateDummyPosts() {
    final now = DateTime.now();
    return [
      Post(
        title: 'Just posted a new photo!',
        timestamp: now.subtract(const Duration(hours: 1)),
        stats: PostStats(likes: 100, comments: 20, shares: 5),
      ),
      Post(
        title: 'Check out my latest blog post',
        timestamp: now.subtract(const Duration(hours: 10)),
        stats: PostStats(likes: 500, comments: 150, shares: 80),
      ),
      Post(
        title: 'Just launched a new project!',
        timestamp: now.subtract(const Duration(days: 2)),
        stats: PostStats(likes: 2000, comments: 400, shares: 200),
      ),
      Post(
        title: 'A funny meme I found',
        timestamp: now.subtract(const Duration(minutes: 30)),
        stats: PostStats(likes: 50, comments: 5, shares: 2),
      ),
      Post(
        title: 'An important announcement',
        timestamp: now.subtract(const Duration(hours: 5)),
        stats: PostStats(likes: 10, comments: 50, shares: 30),
      ),
      Post(
        title: 'Old post that was very popular',
        timestamp: now.subtract(const Duration(days: 30)),
        stats: PostStats(likes: 10000, comments: 2000, shares: 1000),
      ),
    ];
  }

  void _rankPosts() {
    for (var post in _posts) {
      post.score = calculateScore(post);
    }
    // Sort posts in descending order of score
    _posts.sort((a, b) => b.score.compareTo(a.score));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Algorithm'),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final hoursSincePosted =
              DateTime.now().difference(post.timestamp).inHours;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Posted $hoursSincePosted hours ago',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatIcon(Icons.favorite, post.stats.likes),
                      _buildStatIcon(Icons.comment, post.stats.comments),
                      _buildStatIcon(Icons.share, post.stats.shares),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Score:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.score.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/search-algorithm');
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(count.toString()),
      ],
    );
  }
}
