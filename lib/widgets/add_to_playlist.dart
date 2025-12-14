import 'package:appwrite/models.dart' as models;

import 'package:flutter/material.dart';
import 'package:my_app/appwrite_service.dart';
import 'package:provider/provider.dart';

class AddToPlaylistScreen extends StatefulWidget {
  final String postId;
  final String profileId;

  const AddToPlaylistScreen({super.key, required this.postId, required this.profileId});

  @override
  State<AddToPlaylistScreen> createState() => _AddToPlaylistScreenState();
}

class _AddToPlaylistScreenState extends State<AddToPlaylistScreen> {
  late AppwriteService _appwriteService;
  final _formKey = GlobalKey<FormState>();
  String _playlistName = '';
  bool _isCollaborative = false;

  Future<models.RowList>? _playlistsFuture;

  @override
  void initState() {
    super.initState();
    _appwriteService = context.read<AppwriteService>();
    _fetchPlaylists();
  }

  void _fetchPlaylists() {
    setState(() {
      _playlistsFuture = _appwriteService.getPlaylists(widget.profileId);
    });
  }

  void _createPlaylist() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _appwriteService.createPlaylist(
          name: _playlistName,
          isCollaborative: _isCollaborative,
          profileId: widget.profileId,
          postId: widget.postId,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist created and post added!')),
        );
        Navigator.pop(context); // Close the main bottom sheet
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create playlist: $e')),
        );
      }
    }
  }

  void _addPostToExistingPlaylist(String playlistId) async {
    try {
      await _appwriteService.addPostToPlaylist(
        playlistId: playlistId,
        postId: widget.postId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to playlist!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to playlist: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Save to...",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          Flexible(
            child: FutureBuilder<models.RowList>(
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
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    
                    // Correctly read from the 'post_ids' array field
                    final postIds = List<String>.from(playlist.data['post_ids'] ?? []);
                    final isChecked = postIds.contains(widget.postId);
                    final title = playlist.data['name']?.toString() ?? 'Untitled Playlist';
                    
                    return _buildPlaylistItem(
                      title: title,
                      subtitle: "${postIds.length} posts",
                      isChecked: isChecked,
                      onTap: (value) {
                        if (value == true) {
                          _addPostToExistingPlaylist(playlist.$id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          InkWell(
            onTap: () {
              _showCreatePlaylistDialog();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 28),
                  const SizedBox(width: 20),
                  Text(
                    "New playlist",
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isDialogCollaborative = false; 
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('New Playlist'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Playlist Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a playlist name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _playlistName = value!;
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Collaborative'),
                      value: isDialogCollaborative,
                      onChanged: (value) {
                        setDialogState(() {
                           isDialogCollaborative = value!;
                           _isCollaborative = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(dialogContext);
                      _createPlaylist();
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    ).then((_) => _fetchPlaylists());
  }
  
  Widget _buildPlaylistItem({
    required String title,
    required String subtitle,
    required bool isChecked,
    required ValueChanged<bool?> onTap,
    bool isPrivate = true,
  }) {
    final theme = Theme.of(context);
    return CheckboxListTile(
      value: isChecked,
      onChanged: onTap,
      activeColor: Colors.blueAccent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      controlAffinity: ListTileControlAffinity.trailing,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 30,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Center(
              child: Icon(Icons.playlist_play, size: 16, color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Row(
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
            ],
          ),
        ],
      ),
    );
  }
}
