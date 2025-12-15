import 'package:appwrite/models.dart';

class Story {
  final String id;
  final String profileId;
  final String mediaUrl;
  final String mediaType;
  final DateTime expiresAt;
  final String? caption;

  Story({
    required this.id,
    required this.profileId,
    required this.mediaUrl,
    required this.mediaType,
    required this.expiresAt,
    this.caption,
  });

  factory Story.fromRow(Row row) {
    return Story(
      id: row.$id,
      profileId: row.data['profileId'],
      mediaUrl: row.data['mediaUrl'],
      mediaType: row.data['mediaType'],
      expiresAt: DateTime.parse(row.data['expiresAt']),
      caption: row.data['caption'],
    );
  }
}
