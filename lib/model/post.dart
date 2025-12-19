import 'package:my_app/model/profile.dart';

enum PostType { text, image, linkPreview, video }

class PostStats {
  int likes;
  int comments;
  final int shares;
  final int views;

  PostStats({this.likes = 0, this.comments = 0, this.shares = 0, this.views = 0});
}

class Post {
  final String id;
  final Profile author;
  final DateTime timestamp;
  final String contentText;
  final PostType type;
  final String? mediaUrl;
  final String? linkUrl;
  final String? linkTitle;
  final PostStats stats;
  double score;
  bool isLiked;
  bool isSaved;

  Post({
    required this.id,
    required this.author,
    required this.timestamp,
    required this.contentText,
    this.type = PostType.text,
    this.mediaUrl,
    this.linkUrl,
    this.linkTitle,
    required this.stats,
    this.score = 0.0,
    this.isLiked = false,
    this.isSaved = false,
  });
}
