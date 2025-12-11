import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/model/post.dart';
import 'package:my_app/widgets/post_item.dart';
import 'package:provider/provider.dart';

class LiveTab extends StatefulWidget {
  final String profileId;
  const LiveTab({super.key, required this.profileId});

  @override
  State<LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends State<LiveTab> {
  late AppwriteService _appwriteService;
  List<Post> _livePosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _fetchLivePosts();
  }

  Future<void> _fetchLivePosts() async {
    try {
      final postsResponse = await _appwriteService.getPostsFromUsers([widget.profileId]);
      final profilesResponse = await _appwriteService.getProfiles();

      final profilesMap = {for (var doc in profilesResponse.rows) doc.$id: doc.data};

      if (mounted) {
        setState(() {
          _livePosts = postsResponse.rows.map((row) {
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
              type: PostType.video,
            );
          }).where((post) => post != null).cast<Post>().toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_livePosts.isEmpty) {
      return const Center(
        child: Text('No live posts at the moment.'),
      );
    }

    return ListView.builder(
      itemCount: _livePosts.length,
      itemBuilder: (context, index) {
        final post = _livePosts[index];
        return PostItem(post: post);
      },
    );
  }
}
