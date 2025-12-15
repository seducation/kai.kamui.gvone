import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/auth_service.dart';
import 'package:my_app/model/profile.dart';
import 'package:my_app/model/story.dart';
import 'package:my_app/story_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StatusRailSection extends StatefulWidget {
  final String title;

  const StatusRailSection({
    super.key,
    required this.title,
  });

  @override
  State<StatusRailSection> createState() => _StatusRailSectionState();
}

class _StatusRailSectionState extends State<StatusRailSection> {
  bool _isLoading = true;
  List<Profile> _profiles = [];
  Profile? _currentUserProfile;
  Map<String, List<Story>> _stories = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final authService = context.read<AuthService>();
      final appwriteService = context.read<AppwriteService>();
      final user = await authService.getCurrentUser();

      if (user != null && mounted) {
        final userProfiles = await appwriteService.getUserProfiles(ownerId: user.id);
        if (userProfiles.rows.isNotEmpty) {
          _currentUserProfile = Profile.fromRow(userProfiles.rows.first);
        }

        final followingProfiles = await appwriteService.getFollowingProfiles(userId: user.id);
        _profiles = followingProfiles.rows.map((row) => Profile.fromRow(row)).toList();

        final profileIds = _profiles.map((p) => p.id).toList();
        if (_currentUserProfile != null) {
          profileIds.insert(0, _currentUserProfile!.id);
        }

        final storiesResponse = await appwriteService.getStories(profileIds);
        final stories = storiesResponse.rows.map((row) => Story.fromRow(row)).toList();

        final storiesMap = <String, List<Story>>{};
        for (final story in stories) {
          storiesMap.putIfAbsent(story.profileId, () => []).add(story);
        }
        _stories = storiesMap;
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasStory = _currentUserProfile != null && _stories.containsKey(_currentUserProfile!.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _isLoading ? 5 : 1 + _profiles.length,
            itemBuilder: (context, index) {
              if (_isLoading) {
                return const ShimmerCirclePlaceholder();
              }

              if (index == 0) {
                return AddToStoryWidget(
                  hasStory: hasStory,
                  onTap: () {
                    if (hasStory) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StoryViewScreen(
                          stories: _stories[_currentUserProfile!.id]!,
                          profile: _currentUserProfile!,
                        ),
                      ));
                    } else {
                      context.go('/add_to_story');
                    }
                  },
                );
              }

              final profile = _profiles[index - 1];
              final stories = _stories[profile.id] ?? [];
              return StatusItemWidget(profile: profile, stories: stories);
            },
          ),
        ),
      ],
    );
  }
}

class AddToStoryWidget extends StatelessWidget {
  final bool hasStory;
  final VoidCallback onTap;

  const AddToStoryWidget({
    super.key,
    required this.hasStory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
                ),
                if (hasStory)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Add to Story',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusItemWidget extends StatelessWidget {
  final Profile profile;
  final List<Story> stories;

  const StatusItemWidget({
    super.key,
    required this.profile,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    final appwriteService = context.read<AppwriteService>();
    return GestureDetector(
      onTap: () {
        if (stories.isNotEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StoryViewScreen(stories: stories, profile: profile),
          ));
        }
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: profile.profileImageUrl != null
                  ? NetworkImage(appwriteService.getFileViewUrl(profile.profileImageUrl!))
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerCirclePlaceholder extends StatelessWidget {
  const ShimmerCirclePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 60,
              height: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
