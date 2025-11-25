import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/setting_widget/dark_list_tile.dart';
import 'package:my_app/setting_widget/dashboard_widget.dart';
import 'package:my_app/travel_navigation_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/setting_widget/train_widget.dart';

class AboutSearches extends StatefulWidget {
  const AboutSearches({super.key});

  @override
  State<AboutSearches> createState() => _AboutSearchesState();
}

class _AboutSearchesState extends State<AboutSearches> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _showTrainSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _showTrainSearch = !_showTrainSearch;
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Mock search results
      _searchResults = List.generate(
        10,
        (index) => {
          'name': '$query result $index',
          'description': 'This is a mock description for result $index',
        },
      );
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildToolIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildSubscriptionTile(String name) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInitialLayout() {
    final List<MenuItem> menuItems = [
      MenuItem(title: "Liquid Glass", type: ItemType.history),
      MenuItem(title: "Apple", type: ItemType.navigation),
      MenuItem(title: "Mac", type: ItemType.navigation),
      MenuItem(title: "Store", type: ItemType.navigation),
      MenuItem(title: "iPad", type: ItemType.navigation),
      MenuItem(title: "iPhone", type: ItemType.navigation),
    ];

    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120),
                const Center(
                  child: Text(
                    'My App',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                if (_showTrainSearch)
                  TrainSearchWidget(onToggle: _toggleSearch)
                else
                  Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.swap_horiz, color: Colors.grey),
                              onPressed: _toggleSearch,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.mic, color: Colors.grey),
                            const SizedBox(width: 12),
                          ],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                const DashboardWidget(),
                const SizedBox(height: 24),
                const Text(
                  'Tools',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildToolIcon(Icons.science_outlined, 'Labs'),
                    _buildToolIcon(Icons.list_alt_outlined, 'Lits'),
                    _buildToolIcon(Icons.payment, 'Payment'),
                    _buildToolIcon(Icons.construction_outlined, 'Tools'),
                    _buildToolIcon(Icons.history, 'History'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Subscription',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildSubscriptionTile('R4'),
                          const SizedBox(height: 8),
                          _buildSubscriptionTile('R5'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildSubscriptionTile('R1')),
                              const SizedBox(width: 8),
                              Expanded(child: _buildSubscriptionTile('R2')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildSubscriptionTile('R3'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const ShortsRail(),
                const SizedBox(height: 24),
                const TravelNavigationCard(),
                const SizedBox(height: 24),
                const AppleStoreDifferenceCard(),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'show more',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildToolIcon(Icons.settings, 'S1'),
                    _buildToolIcon(Icons.settings, 'S2'),
                    _buildToolIcon(Icons.settings, 'S3'),
                    _buildToolIcon(Icons.settings, 'S4'),
                    _buildToolIcon(Icons.settings, 'S5'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildToolIcon(Icons.settings, 'S6'),
                    _buildToolIcon(Icons.settings, 'S7'),
                    _buildToolIcon(Icons.settings, 'S8'),
                    _buildToolIcon(Icons.settings, 'S9'),
                    _buildToolIcon(Icons.settings, 'S10'),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Insight',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Graph Area',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const CarouselScreen(),
                const SizedBox(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: menuItems.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 0,
                  ),
                  itemBuilder: (context, index) {
                    return DarkListTile(item: menuItems[index]);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        context.go('/profile');
                      },
                    ),
                    const SizedBox(width: 8),
                    // Placeholder for weather widget
                    const Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('25°C', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Placeholder for location widget
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 4),
                        Text('New York', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchLayout() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _searchResults = [];
              });
            },
          ),
          title: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.swap_horiz, color: Colors.grey),
                      onPressed: _toggleSearch,
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.mic, color: Colors.grey),
                    const SizedBox(width: 12),
                  ],
                ),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          pinned: true,
        ),
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No results found.'),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final hit = _searchResults[index];
                return ListTile(
                  title: Text(hit['name'] ?? 'No name'),
                  subtitle: Text(hit['description'] ?? ''),
                );
              },
              childCount: _searchResults.length,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isSearching ? _buildSearchLayout() : _buildInitialLayout(),
    );
  }
}

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  // Controller to handle page snapping and viewport fraction
  // viewportFraction: 0.85 allows the next card to peek through on the right
  final PageController _pageController = PageController(viewportFraction: 0.85);
  
  int _currentPage = 0;

  final List<CarouselItem> _items = [
    CarouselItem(
      title: "Wide field-of-view video support.",
      description: "With support for native playback of 360°, 180°, and wide field-of-view video, you can relive and share exciting moments as they were meant to be seen.",
      imageUrl: "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?auto=format&fit=crop&q=80&w=800", // Skiing/Winter placeholder
    ),
    CarouselItem(
      title: "New immersive experiences.",
      description: "Experience extra perspectives that put you in the center of the action. From sporting events to thrilling concerts.",
      imageUrl: "https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&q=80&w=800", // Racing/Gaming placeholder
    ),
    CarouselItem(
      title: "Spatial Audio that surrounds you.",
      description: "Advanced Spatial Audio places sounds all around you, making every experience feel like you're actually there.",
      imageUrl: "https://images.unsplash.com/photo-1478737270239-2f02b77ac6d5?auto=format&fit=crop&q=80&w=800", // Music/Audio placeholder
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Listen to page changes to update UI state if needed
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. The Carousel Section
            SizedBox(
              height: 550, // Fixed height for the card area
              child: PageView.builder(
                controller: _pageController,
                padEnds: false, // Aligns first item to the start (left)
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  // Add padding between cards
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0), // Margins
                    child: FeatureCard(item: _items[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 2. Navigation Buttons (Bottom Right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _NavButton(
                    icon: Icons.chevron_left,
                    onTap: _prevPage,
                    isEnabled: _currentPage > 0,
                  ),
                  const SizedBox(width: 16),
                  _NavButton(
                    icon: Icons.chevron_right,
                    onTap: _nextPage,
                    isEnabled: _currentPage < _items.length - 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets & Models ---

class FeatureCard extends StatelessWidget {
  final CarouselItem item;

  const FeatureCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Container
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
              image: DecorationImage(
                image: NetworkImage(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Text Content
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1F),
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF424245), // Dark grey
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled ? Colors.grey[300] : Colors.grey[200],
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled ? Colors.black87 : Colors.grey[400],
            size: 24,
          ),
        ),
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String description;
  final String imageUrl;

  CarouselItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
class ShortsRail extends StatelessWidget {
  const ShortsRail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shorts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // Example count
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text('Short ${index + 1}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AppleStoreDifferenceCard extends StatelessWidget {
  const AppleStoreDifferenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 28, height: 1.1),
              children: [
                TextSpan(
                  text: "The Apple Store difference. ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Even more reasons to shop with us.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF86868b), // Apple's distinct grey
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 240, // Height constraint for the horizontal list
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24), // Left/Right padding for the list
            physics: const BouncingScrollPhysics(), // iOS style bounce
            children: [
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(), // Push content roughly to middle/top visually
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(text: "No Cost EMI."),
                          _buildSuperscript("§"),
                          const TextSpan(text: " Plus Instant\nCashback."),
                          _buildSuperscript("§§"),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(width: 20), // Spacing between cards
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Stack(
                        children: [
                          Icon(CupertinoIcons.device_laptop, size: 36, color: Colors.blue.shade600),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(CupertinoIcons.device_phone_portrait, size: 20, color: Colors.blue.shade600),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(CupertinoIcons.arrow_2_circlepath, size: 18, color: Colors.blue.shade600),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: "Exchange your smartphone, ",
                            style: TextStyle(color: Colors.blue.shade600, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: "get ₹3350.00 – ₹64000.00 credit towards a new one.*"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              _buildCard(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_shipping_outlined, color: Colors.green.shade600, size: 40),
                    const Spacer(),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15, color: Colors.black, height: 1.4),
                        children: [
                          TextSpan(
                            text: "Free delivery, ",
                            style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: "on all orders. Get it delivered to your doorstep quickly and safely."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      width: 300, // Fixed width for the cards
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Large rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  WidgetSpan _buildSuperscript(String text) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.top,
      child: Transform.translate(
        offset: const Offset(2, 0), // Move slightly right
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
