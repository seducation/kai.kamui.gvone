import 'package:appwrite/models.dart' as models;

/// Represents a single RSS feed item cached as a TV Post
class TVPost {
  final String id;
  final String tvProfileId;
  final String postRefId; // Unique hash(rss_url + guid)
  final String title;
  final String url; // Original article URL
  final DateTime publishedAt;
  final String? description;
  final String? imageUrl;
  int likesCount;
  int commentsCount;
  double engagementScore;
  bool isLiked;
  final DateTime createdAt; // When we fetched it

  TVPost({
    required this.id,
    required this.tvProfileId,
    required this.postRefId,
    required this.title,
    required this.url,
    required this.publishedAt,
    this.description,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.engagementScore = 0.0,
    this.isLiked = false,
    required this.createdAt,
  });

  /// Create from Appwrite Row
  factory TVPost.fromRow(models.Row row) {
    return TVPost(
      id: row.$id,
      tvProfileId: row.data['tv_profile_id'] ?? '',
      postRefId: row.data['post_ref_id'] ?? '',
      title: row.data['title'] ?? '',
      url: row.data['url'] ?? '',
      publishedAt: DateTime.parse(row.data['published_at'] ?? row.$createdAt),
      description: row.data['description'],
      imageUrl: row.data['image_url'],
      likesCount: row.data['likes_count'] ?? 0,
      commentsCount: row.data['comments_count'] ?? 0,
      engagementScore: (row.data['engagement_score'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(row.$createdAt),
    );
  }

  /// Create from Map
  factory TVPost.fromMap(Map<String, dynamic> data, String id) {
    return TVPost(
      id: id,
      tvProfileId: data['tv_profile_id'] ?? '',
      postRefId: data['post_ref_id'] ?? '',
      title: data['title'] ?? '',
      url: data['url'] ?? '',
      publishedAt: DateTime.parse(
        data['published_at'] ?? DateTime.now().toIso8601String(),
      ),
      description: data['description'],
      imageUrl: data['image_url'],
      likesCount: data['likes_count'] ?? 0,
      commentsCount: data['comments_count'] ?? 0,
      engagementScore: (data['engagement_score'] ?? 0.0).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Convert to Map for Appwrite
  Map<String, dynamic> toMap() {
    return {
      'tv_profile_id': tvProfileId,
      'post_ref_id': postRefId,
      'title': title,
      'url': url,
      'published_at': publishedAt.toIso8601String(),
      'description': description,
      'image_url': imageUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'engagement_score': engagementScore,
    };
  }

  /// Get formatted published time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
