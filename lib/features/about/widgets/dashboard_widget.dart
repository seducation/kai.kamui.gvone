import 'package:flutter/material.dart';
import 'package:my_app/features/about/widgets/follower_card_widget.dart';
import 'package:my_app/features/about/widgets/likes_stat_widget.dart';
import 'package:my_app/features/about/widgets/games_stat_widget.dart';
import 'package:my_app/features/about/widgets/lens_stat_widget.dart';
import 'package:my_app/features/about/widgets/following_stat_widget.dart';
import 'package:my_app/features/about/widgets/saved_stat_widget.dart';
import 'package:my_app/features/about/widgets/history_stat_widget.dart';
import 'package:my_app/features/about/widgets/groups_stat_widget.dart';
import 'package:my_app/features/about/widgets/websites_stat_widget.dart';
import 'package:my_app/features/about/widgets/memories_stat_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  // State variables to simulate dynamic data
  String followerCount = "127,225";
  double followerPercentChange = -0.05;
  String followingCount = "1,234";
  String likesCount = "5,678";
  String savedCount = "42";
  String historyCount = "108";
  String gamesCount = "9";
  String lensCount = "3";
  String groupsCount = "7";
  String websitesCount = "21";
  String memoriesCount = "14";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FollowerCardWidget(
            followerCount: followerCount,
            followerPercentChange: followerPercentChange,
          ),
          const SizedBox(width: 12),
          FollowingStatWidget(count: followingCount),
          const SizedBox(width: 12),
          LikesStatWidget(count: likesCount),
          const SizedBox(width: 12),
          SavedStatWidget(count: savedCount),
          const SizedBox(width: 12),
          HistoryStatWidget(count: historyCount),
          const SizedBox(width: 12),
          GamesStatWidget(count: gamesCount),
          const SizedBox(width: 12),
          LensStatWidget(count: lensCount),
          const SizedBox(width: 12),
          GroupsStatWidget(count: groupsCount),
          const SizedBox(width: 12),
          WebsitesStatWidget(count: websitesCount),
          const SizedBox(width: 12),
          MemoriesStatWidget(count: memoriesCount),
        ],
      ),
    );
  }
}
