
import 'package:flutter/material.dart';

class FollowerCardWidget extends StatelessWidget {
  final String followerCount;
  final double followerPercentChange;

  const FollowerCardWidget({
    super.key,
    required this.followerCount,
    required this.followerPercentChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Label and Percentage
          Row(
            children: [
              const Text(
                "Follower",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "$followerPercentChange%",
                style: const TextStyle(
                  color: Color(0xFFE57373), // Salmon/Red color
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // Bottom Row: Price and Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                followerCount,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B2D2D), // Dark Red circle
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                  size: 18,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
