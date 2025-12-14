import 'package:flutter/material.dart';

class PlaylistsTab extends StatelessWidget {
  final String profileId;
  const PlaylistsTab({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Playlists Content", style: TextStyle(color: Colors.white)),
    );
  }
}
