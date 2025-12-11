import 'package:flutter/material.dart';

class VideosTab extends StatelessWidget {
  final String profileId;
  const VideosTab({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Videos Content", style: TextStyle(color: Colors.white)),
    );
  }
}
