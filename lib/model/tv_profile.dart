import 'package:appwrite/models.dart' as models;

/// Represents a TV Profile (publisher/website)
/// Used for RSS-based content aggregation
class TVProfile {
  final String id;
  final String name;
  final String domain;
  final List<String> rssUrls;
  final String? logoUrl; // File ID from Appwrite Storage
  final String category; // Tech, News, Education, Business, Entertainment
  final String subscriptionTier; // Basic, Pro, Enterprise
  final DateTime? subscriptionExpiry;
  final String status; // active, paused, expired
  final int followersCount;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? bio;

  TVProfile({
    required this.id,
    required this.name,
    required this.domain,
    required this.rssUrls,
    this.logoUrl,
    required this.category,
    this.subscriptionTier = 'Basic',
    this.subscriptionExpiry,
    this.status = 'active',
    this.followersCount = 0,
    this.verified = false,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
  });

  /// Create from Appwrite Row
  factory TVProfile.fromRow(models.Row row) {
    return TVProfile(
      id: row.$id,
      name: row.data['name'] ?? '',
      domain: row.data['domain'] ?? '',
      rssUrls: (row.data['rss_urls'] as List?)?.cast<String>() ?? [],
      logoUrl: row.data['logo_url'],
      category: row.data['category'] ?? 'Tech',
      subscriptionTier: row.data['subscription_tier'] ?? 'Basic',
      subscriptionExpiry: row.data['subscription_expiry'] != null
          ? DateTime.parse(row.data['subscription_expiry'])
          : null,
      status: row.data['status'] ?? 'active',
      followersCount: row.data['followers_count'] ?? 0,
      verified: row.data['verified'] ?? false,
      createdAt: DateTime.parse(row.$createdAt),
      updatedAt: DateTime.parse(row.$updatedAt),
      bio: row.data['bio'],
    );
  }

  /// Create from Map
  factory TVProfile.fromMap(Map<String, dynamic> data, String id) {
    return TVProfile(
      id: id,
      name: data['name'] ?? '',
      domain: data['domain'] ?? '',
      rssUrls: (data['rss_urls'] as List?)?.cast<String>() ?? [],
      logoUrl: data['logo_url'],
      category: data['category'] ?? 'Tech',
      subscriptionTier: data['subscription_tier'] ?? 'Basic',
      subscriptionExpiry: data['subscription_expiry'] != null
          ? DateTime.parse(data['subscription_expiry'])
          : null,
      status: data['status'] ?? 'active',
      followersCount: data['followers_count'] ?? 0,
      verified: data['verified'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      bio: data['bio'],
    );
  }

  /// Convert to Map for Appwrite
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'domain': domain,
      'rss_urls': rssUrls,
      'logo_url': logoUrl,
      'category': category,
      'subscription_tier': subscriptionTier,
      'subscription_expiry': subscriptionExpiry?.toIso8601String(),
      'status': status,
      'followers_count': followersCount,
      'verified': verified,
      'bio': bio,
    };
  }

  /// Check if subscription is active
  bool get isSubscriptionActive {
    if (status != 'active') return false;
    if (subscriptionExpiry == null) return true;
    return subscriptionExpiry!.isAfter(DateTime.now());
  }

  /// Get display domain (without www)
  String get displayDomain {
    return domain.replaceFirst('www.', '');
  }
}
