class Profile {
  final String id;
  final String name;
  final String? bio;
  final String? imageUrl;

  Profile({
    required this.id,
    required this.name,
    this.bio,
    this.imageUrl,
  });

  factory Profile.fromMap(Map<String, dynamic> map, String id) {
    return Profile(
      id: id,
      name: map['name'] ?? '',
      bio: map['bio'],
      imageUrl: map['imageUrl'],
    );
  }
}
