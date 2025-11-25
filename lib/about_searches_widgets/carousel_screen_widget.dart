import 'package:flutter/material.dart';

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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
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