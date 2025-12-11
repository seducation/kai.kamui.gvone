import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/model/post.dart';
import 'package:video_player/video_player.dart';

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.post.type == PostType.video && widget.post.mediaUrl != null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.mediaUrl!))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(widget.post.author.avatarUrl),
                  radius: 20,
                ),
                const SizedBox(width: 12.0),
                Text(widget.post.author.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          if (widget.post.caption != null && widget.post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(widget.post.caption!),
            ),
          if (widget.post.type == PostType.image && widget.post.mediaUrl != null)
            CachedNetworkImage(
              imageUrl: widget.post.mediaUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(height: 250, color: Colors.grey[300]),
              errorWidget: (context, url, error) => Container(height: 250, color: Colors.red[100], child: const Icon(Icons.error)),
            ),
          if (widget.post.type == PostType.video && _controller != null && _controller!.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller!),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                      });
                    },
                    child: Icon(
                      _controller!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: const Color.fromRGBO(255, 255, 255, 0.7),
                      size: 60,
                    ),
                  ),
                ],
              ),
            )
          else if (widget.post.type == PostType.video)
             Container(height: 250, color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
