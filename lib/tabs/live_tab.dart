import 'package:flutter/material.dart';

class LiveTab extends StatelessWidget {
  final String profileId;
  const LiveTab({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No live posts at the moment.'),
    );
  }
}
