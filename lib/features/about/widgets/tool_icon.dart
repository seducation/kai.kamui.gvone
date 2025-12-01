import 'package:flutter/material.dart';

class ToolIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const ToolIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
