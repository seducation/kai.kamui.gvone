enum PostType { text, image, video }

class User {
  final String name;
  final String avatarUrl;

  User({
    required this.name,
    required this.avatarUrl,
  });
}

class Post {
  final String id;
  final User author;
  final DateTime timestamp;
  final String? mediaUrl;
  final String? caption;
  final PostType type;

  Post({
    required this.id,
    required this.author,
    required this.timestamp,
    this.mediaUrl,
    this.caption,
    required this.type,
  });
}
