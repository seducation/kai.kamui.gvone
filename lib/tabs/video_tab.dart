import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/model/post.dart';
import 'package:my_app/widgets/post_item.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideosTab extends StatefulWidget {
  final String profileId;
  const VideosTab({super.key, required this.profileId});
  @override
  State<VideosTab> createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  late AppwriteService _appwriteService;
  List<Post> _videoPosts = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _loadVideoPosts();
  }

  Future<void> _loadVideoPosts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final postsResponse = await _appwriteService.getPostsFromUsers([widget.profileId]);
      final profilesResponse = await _appwriteService.getProfiles();

      final profilesMap = {for (var doc in profilesResponse.rows) doc.$id: doc.data};

      if (!mounted) return;
      setState(() {
        _videoPosts = postsResponse.rows.map((row) {
            final creatorProfileData = profilesMap[row.data['profile_id']];
            if (creatorProfileData == null) return null;

            final authorName = creatorProfileData['name'];
            final profileImageUrl = creatorProfileData['profileImageUrl'];

            final author = User(
              name: authorName,
              avatarUrl: profileImageUrl != null && profileImageUrl.isNotEmpty
                  ? _appwriteService.getFileViewUrl(profileImageUrl)
                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            );

            return Post(
              id: row.$id,
              author: author,
              timestamp: DateTime.tryParse(row.data['timestamp'] ?? '') ?? DateTime.now(),
              mediaUrl: row.data['file_ids'] != null && row.data['file_ids'].isNotEmpty ? _appwriteService.getFileViewUrl(row.data['file_ids'].first) : null,
              caption: row.data['caption'],
              type: _getPostType(row.data['type']),
            );
          }).where((post) => post != null && post.type == PostType.video).cast<Post>().toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  PostType _getPostType(String? type) {
    switch (type) {
      case 'image':
        return PostType.image;
      case 'video':
        return PostType.video;
      default:
        return PostType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _videoPosts.isEmpty
            ? const Center(child: Text("No videos found"))
            : ListView.builder(
                itemCount: _videoPosts.length,
                itemBuilder: (context, index) {
                  final post = _videoPosts[index];
                  return VisibilityDetector(
                    key: Key(post.id),
                    onVisibilityChanged: (visibilityInfo) {
                      var visiblePercentage = visibilityInfo.visibleFraction * 100;
                      if (visiblePercentage > 50) {
                        // Autoplay logic can be implemented here
                      }
                    },
                    child: PostItem(post: post),
                  );
                },
              );
  }
}
