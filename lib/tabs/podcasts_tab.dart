import 'package:flutter/material.dart';

class PodcastsTab extends StatelessWidget {
  final String profileId;
  const PodcastsTab({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Podcasts Content", style: TextStyle(color: Colors.white)),
    );
  }
}
