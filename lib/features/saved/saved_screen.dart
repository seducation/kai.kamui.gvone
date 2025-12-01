import 'package:flutter/material.dart';

// --- DUMMY DATA ---
// (In a real app, this data would come from an API)

class Collection {
  final String name;
  final String imageUrl;
  final bool isPrivate;
  Collection(this.name, this.imageUrl, this.isPrivate);
}

class SavedPost {
  final String username;
  final String imageUrl;
  final String caption;
  final int likes;
  SavedPost(this.username, this.imageUrl, this.caption, this.likes);
}

final List<Collection> dummyCollections = [
  Collection(
    "Clothing & Accessories",
    'https://i.imgur.com/r6w5g3e.jpg', // Placeholder image URL
    true,
  ),
  Collection(
    "For Later",
    'https://i.imgur.com/J8t4cM9.jpg', // Placeholder image URL
    true,
  ),
];

final List<SavedPost> dummyPosts = [
  SavedPost(
    'Omar Vts Boyshayari',
    'https://i.imgur.com/1vB2j7j.jpg', // Placeholder image URL for BTS V
    'Follow me.. #instagram #trending...',
    2000,
  ),
  SavedPost(
    'Sabari Mondal',
    'https://i.imgur.com/vHqJ9y3.jpg', // Placeholder image URL for necklace/man
    'এতটা সুন্দর না হলেও পারতো, তোমাকে দেখার.', // Bengali text from image
    4700,
  ),
  SavedPost(
    'Nancy_Fanpage90',
    'https://i.imgur.com/0vT2g8k.jpg', // Placeholder image URL for dark post
    '',
    0,
  ),
  SavedPost(
    'Taekook forever - BTS',
    'https://i.imgur.com/i9t4u3w.jpg', // Placeholder image URL for Taekook
    '',
    0,
  ),
];

// --- MAIN APPLICATION SETUP ---

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Defines the tabs for the navigation bar
    const List<Tab> tabs = [
      Tab(text: 'All'),
      Tab(text: 'Reels'),
      Tab(text: 'Posts'),
      Tab(text: 'Marketplace'),
      Tab(text: 'Collections'),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Saved',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: const TabBar(
            tabs: tabs,
            isScrollable: true,
            // Style to match the image (white indicator under the selected tab)
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // Only the 'All' tab (index 0) will contain the main content
        body: TabBarView(
          children: [
            const _SavedContentView(), // Main content goes here
            // Empty containers for the other tabs
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}

// --- SAVED CONTENT VIEW (COLLECTIONS + RECENTLY SAVED) ---

class _SavedContentView extends StatelessWidget {
  const _SavedContentView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Collections Header and 'New Collection' Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Collections',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'New collection',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Collections Grid
            _CollectionsGrid(collections: dummyCollections),

            const SizedBox(height: 30),

            // Recently Saved Header
            const Text(
              'Recently saved',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Recently Saved Posts Grid
            _RecentlySavedGrid(posts: dummyPosts),
          ],
        ),
      ),
    );
  }
}

// --- COLLECTIONS GRID WIDGET ---

class _CollectionsGrid extends StatelessWidget {
  final List<Collection> collections;
  const _CollectionsGrid({required this.collections});

  @override
  Widget build(BuildContext context) {
    // The height is set to accommodate two items comfortably
    return SizedBox(
      height: 250,
      child: GridView.builder(
        // Must disable scrolling as it's inside a SingleChildScrollView
        physics: const NeverScrollableScrollPhysics(),
        itemCount: collections.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8, // Adjust aspect ratio for a taller card
        ),
        itemBuilder: (context, index) {
          final collection = collections[index];
          return _CollectionItem(collection: collection);
        },
      ),
    );
  }
}

// --- SINGLE COLLECTION ITEM WIDGET ---

class _CollectionItem extends StatelessWidget {
  final Collection collection;
  const _CollectionItem({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              // Image Container
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: collection.imageUrl.isEmpty
                    ? Container(color: Colors.grey[800])
                    : Image.network(
                        collection.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              // Private lock icon, positioned bottom-left
              if (collection.isPrivate)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.lock_rounded, color: Colors.white, size: 14),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // Title
        Text(
          collection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        // Subtitle (e.g., 'Only me')
        Text(
          'Only me',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

// --- RECENTLY SAVED GRID WIDGET ---

class _RecentlySavedGrid extends StatelessWidget {
  final List<SavedPost> posts;
  const _RecentlySavedGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // Important for GridView inside a SingleChildScrollView
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.7, // Ratio to match the image-like shape
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return _SavedPostItem(post: post);
      },
    );
  }
}

// --- SINGLE SAVED POST ITEM WIDGET ---

class _SavedPostItem extends StatelessWidget {
  final SavedPost post;
  const _SavedPostItem({required this.post});

  String _formatLikes(int likes) {
    if (likes >= 1000) {
      return '${(likes / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}K';
    }
    return likes.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0), // Posts often have sharp corners
      child: Stack(
        children: [
          // Main Image
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Top-left user info overlay
          Positioned(
            top: 8,
            left: 8,
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 10, backgroundColor: Colors.white), // User Avatar
                const SizedBox(width: 5),
                Text(
                  post.username,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ],
            ),
          ),

          // Bottom overlay for caption/likes/save icon
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              // Gradient for visual depth
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withAlpha(178), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Caption
                  if (post.caption.isNotEmpty)
                    Text(
                      post.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  // Likes/Reactions
                  if (post.likes > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _formatLikes(post.likes),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Save Icon (Top Right)
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.bookmark, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
