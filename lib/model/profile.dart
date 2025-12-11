import 'package:appwrite/models.dart' as models;

class Profile {
  final String id;
  final String name;
  final String type;
  final String? bio;
  final String? profileImageUrl;
  final String ownerId;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.name,
    required this.type,
    this.bio,
    this.profileImageUrl,
    required this.ownerId,
    required this.createdAt,
  });

  factory Profile.fromRow(models.Row row) {
    return Profile(
      id: row.$id,
      name: row.data['name'] ?? '',
      type: row.data['type'] ?? 'profile',
      bio: row.data['bio'],
      profileImageUrl: row.data['profileImageUrl'],
      ownerId: row.data['ownerId'] ?? '',
      createdAt: DateTime.parse(row.$createdAt),
    );
  }

  factory Profile.fromMap(Map<String, dynamic> data, String id) {
    return Profile(
      id: id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'profile',
      bio: data['bio'],
      profileImageUrl: data['profileImageUrl'],
      ownerId: data['ownerId'] ?? '',
      // Using a default value as createdAt is not available in the data map.
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
