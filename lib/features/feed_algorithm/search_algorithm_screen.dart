import 'package:flutter/material.dart';

// --- Data Models ---
class SearchItem {
  final String title;
  final String description;

  SearchItem({required this.title, required this.description});
}

// --- UI ---
class SearchAlgorithmScreen extends StatefulWidget {
  const SearchAlgorithmScreen({super.key});

  @override
  SearchAlgorithmScreenState createState() => SearchAlgorithmScreenState();
}

class SearchAlgorithmScreenState extends State<SearchAlgorithmScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchItem> _items = [];
  List<SearchItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _items = _generateDummyItems();
    _filteredItems = _items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredItems = _items
          .where((item) =>
              item.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              item.description.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  List<SearchItem> _generateDummyItems() {
    return [
      SearchItem(title: 'Flutter', description: 'An open-source UI software development kit created by Google.'),
      SearchItem(title: 'Dart', description: 'A programming language designed for client development, such as for the web and mobile apps.'),
      SearchItem(title: 'Firebase', description: 'A platform developed by Google for creating mobile and web applications.'),
      SearchItem(title: 'Google Cloud Platform', description: 'A suite of cloud computing services that runs on the same infrastructure that Google uses internally.'),
      SearchItem(title: 'Android', description: 'A mobile operating system based on a modified version of the Linux kernel and other open source software.'),
      SearchItem(title: 'iOS', description: 'A mobile operating system created and developed by Apple Inc. exclusively for its hardware.'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Algorithm'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(item.description),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
