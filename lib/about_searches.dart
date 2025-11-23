import 'package:flutter/material.dart';
import 'package:my_app/widgets/name_count_widget.dart';

class AboutSearchesScreen extends StatelessWidget {
  const AboutSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Searches'),
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 16),
          SizedBox(
            height: 100, // Adjust height as needed
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                NameCountWidget(name: 'Topics', count: 12),
                SizedBox(width: 12),
                NameCountWidget(name: 'Users', count: 56),
                SizedBox(width: 12),
                NameCountWidget(name: 'Posts', count: 234),
                SizedBox(width: 12),
                NameCountWidget(name: 'Comments', count: 789),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }
}
