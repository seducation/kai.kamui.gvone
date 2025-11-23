import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/psv_about_tabscreen.dart';
import 'package:my_app/psv_home_tabscreen.dart';
import 'package:my_app/psv_live_tabscreen.dart';
import 'package:my_app/psv_podcasts_tabscreen.dart';
import 'package:my_app/psv_shorts_tabscreen.dart';
import 'package:my_app/psv_videos_tabscreen.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageScreen extends StatefulWidget {
  final String name;
  final String imageUrl;
  const ProfilePageScreen({super.key, required this.name, required this.imageUrl});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Tab Names corresponding to the screenshot
  final List<String> _tabs = ["Home", "Videos", "Shorts", "Live", "Podcasts", "About"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            // 1. THE HERO BANNER (SliverAppBar)
            SliverAppBar(
              expandedHeight: 180.0, // Height of the banner
              pinned: true,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => context.go('/search'),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.black),
                  ),
                ),
              ),
            ),

            // 2. PROFILE INFO SECTION (Non-sticky content)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar and Title Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.name,
                                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. STICKY TAB BAR
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.secondary,
                  indicatorColor: theme.colorScheme.primary,
                  dividerColor: Colors.transparent, // Removes the line below tabs
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        // 4. TAB CONTENT BODY
        body: TabBarView(
          controller: _tabController,
          children: const [
            PsvHomeTabscreen(),
            PsvVideosTabscreen(),
            PsvShortsTabscreen(),
            PsvLiveTabscreen(),
            PsvPodcastsTabscreen(),
            PsvAboutTabscreen(),
          ],
        ),
      ),
    );
  }
}

// Helper class to make the TabBar stick to the top
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
