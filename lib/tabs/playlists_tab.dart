import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:my_app/playlist_detail_screen.dart';
import 'package:provider/provider.dart';

class PlaylistsTab extends StatefulWidget {
  final String profileId;
  const PlaylistsTab({super.key, required this.profileId});

  @override
  State<PlaylistsTab> createState() => _PlaylistsTabState();
}

class _PlaylistsTabState extends State<PlaylistsTab> {
  late AppwriteService _appwriteService;
  Future<models.RowList>? _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _playlistsFuture = _appwriteService.getPlaylists(widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<models.RowList>(
      future: _playlistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.rows.isEmpty) {
          return const Center(child: Text("No playlists found."));
        }

        final playlists = snapshot.data!.rows;
        return ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            final postIds = List<String>.from(playlist.data['post_ids'] ?? []);
            final title =
                playlist.data['name']?.toString() ?? 'Untitled Playlist';
            final isPrivate = playlist.data['isPrivate'] ?? true;

            return _buildPlaylistItem(
              playlistId: playlist.$id,
              title: title,
              subtitle: "${postIds.length} posts",
              isPrivate: isPrivate,
            );
          },
        );
      },
    );
  }

  Widget _buildPlaylistItem({
    required String playlistId,
    required String title,
    required String subtitle,
    required bool isPrivate,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Center(
          child: Icon(Icons.playlist_play,
              size: 24, color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          if (isPrivate) ...[
            Icon(Icons.lock, size: 12, color: theme.disabledColor),
            const SizedBox(width: 4),
          ],
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailScreen(
              playlistId: playlistId,
              playlistName: title,
              profileId: widget.profileId,
            ),
          ),
        );
      },
    );
  }
}
