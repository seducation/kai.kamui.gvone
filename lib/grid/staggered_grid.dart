import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class StaggeredGridScreen extends StatelessWidget {
  const StaggeredGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the grid
    final List<GridTileData> tiles = [
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=500&q=80',
        title: 'Mountain Retreat',
        isLarge: true,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=500&q=80',
        title: 'Serene Lake',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=500&q=80',
        title: 'Lush Forest',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=500&q=80',
        title: 'Golden Fields',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=500&q=80',
        title: 'Cozy Cabin',
        isLarge: true,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=500&q=80',
        title: 'Sunset Peak',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=500&q=80',
        title: 'Morning Dew',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1433086566086-6460010c950d?w=500&q=80',
        title: 'Waterfall',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1518173946687-a4c8a3b7724e?w=500&q=80',
        title: 'Desert Dunes',
        isLarge: true,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=500&q=80',
        title: 'Coastal View',
        isLarge: false,
      ),
      GridTileData(
        imageUrl:
            'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=500&q=80',
        title: 'Bloom',
        isLarge: false,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Explore',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StairedGridView(tiles: tiles),
      ),
    );
  }
}

class StairedGridView extends StatelessWidget {
  final List<GridTileData> tiles;

  const StairedGridView({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StaggeredGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: tiles.map((tile) {
          return StaggeredGridTile.count(
            crossAxisCellCount: tile.isLarge ? 2 : 1,
            mainAxisCellCount: tile.isLarge
                ? 2
                : 1.3, // 1.3 to accommodate the title below
            child: StaggeredTileItem(tile: tile),
          );
        }).toList(),
      ),
    );
  }
}

class StaggeredTileItem extends StatelessWidget {
  final GridTileData tile;

  const StaggeredTileItem({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: tile.isLarge ? 1 : 3,
            child: CachedNetworkImage(
              imageUrl: tile.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          if (!tile.isLarge)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tile.title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class GridTileData {
  final String imageUrl;
  final String title;
  final bool isLarge;

  GridTileData({
    required this.imageUrl,
    required this.title,
    required this.isLarge,
  });
}
