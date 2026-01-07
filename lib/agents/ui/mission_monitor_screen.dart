import 'package:flutter/material.dart';
import 'dart:async';
import '../coordination/mission_controller.dart';
import 'widgets/risk_forecast_widget.dart';

/// Screen to monitor active missions and simulations
class MissionMonitorScreen extends StatefulWidget {
  const MissionMonitorScreen({super.key});

  @override
  State<MissionMonitorScreen> createState() => _MissionMonitorScreenState();
}

class _MissionMonitorScreenState extends State<MissionMonitorScreen> {
  Timer? _refreshTimer;
  final MissionController _controller = MissionController();

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final missions = _controller.allMissions;
    final active = _controller.activeMission;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Mission Control'),
        backgroundColor: Colors.black,
        actions: [
          if (active != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildConfidenceBadge(active.confidencePercent),
              ),
            ),
        ],
      ),
      body: missions.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                if (active != null) _buildActiveMissionCard(active),
                Expanded(
                  child: ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final mission = missions[index];
                      if (mission.id == active?.id) {
                        return const SizedBox.shrink(); // Skip active
                      }
                      return _buildMissionTile(mission);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateMissionDialog(context),
        icon: const Icon(Icons.add_task),
        label: const Text('New Mission'),
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
      ),
    );
  }

  Widget _buildActiveMissionCard(Mission mission) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withValues(alpha: 0.2),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CURRENT MISSION',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
              _buildStatusBadge(mission.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mission.objective,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar('Progress', mission.progressPercent, Colors.green),
          const SizedBox(height: 8),
          _buildProgressBar('Confidence', mission.confidencePercent,
              _getConfidenceColor(mission.confidencePercent)),
          const SizedBox(height: 16),
          _buildSectionTitle('Constraints'),
          ...mission.constraints
              .map((c) => _buildBullet(c, Colors.orangeAccent)),
          const SizedBox(height: 8),
          _buildSectionTitle('Success Criteria'),
          ...mission.successCriteria.map((c) {
            final isDone = mission.completedCriteria.contains(c);
            return _buildCheckbox(c, isDone);
          }),
          const SizedBox(height: 16),
          // Phase 11 Integration: Risk Forecast
          RiskForecastWidget(
            successProbability: mission.confidencePercent / 100,
            riskFactors: mission.confidencePercent < 60
                ? ['Low plan confidence detected', 'Possible logic drift']
                : [],
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTile(Mission mission) {
    return ListTile(
      title:
          Text(mission.objective, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${mission.status.name.toUpperCase()} • ${mission.progressPercent.toStringAsFixed(0)}%',
        style: TextStyle(color: Colors.white70),
      ),
      trailing: _buildStatusBadge(mission.status),
      onTap: () => _showMissionDetails(context, mission),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.rocket_launch, size: 64, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'No Active Missions',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBadge(double confidence) {
    final color = _getConfidenceColor(confidence);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${(confidence).toStringAsFixed(0)}% CONFIDENCE',
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildStatusBadge(MissionStatus status) {
    Color color;
    switch (status) {
      case MissionStatus.active:
        color = Colors.green;
        break;
      case MissionStatus.planning:
        color = Colors.blue;
        break;
      case MissionStatus.paused:
        color = Colors.orange;
        break;
      case MissionStatus.completed:
        color = Colors.cyan;
        break;
      case MissionStatus.failed:
        color = Colors.red;
        break;
      case MissionStatus.aborted:
        color = Colors.grey;
        break;
      case MissionStatus.monitoring:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text('${value.toStringAsFixed(0)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value / 100,
          backgroundColor: Colors.white12,
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildBullet(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String text, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: checked ? Colors.greenAccent : Colors.white30,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: checked ? Colors.white : Colors.white54,
                decoration: checked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateMissionDialog(BuildContext context) {
    final objectiveController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('New Mission',
            style: TextStyle(color: Colors.cyanAccent)),
        content: TextField(
          controller: objectiveController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Objective',
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
            onPressed: () {
              if (objectiveController.text.isNotEmpty) {
                _controller.createMission(Mission(
                  objective: objectiveController.text,
                  status: MissionStatus.active,
                ));
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Deploy', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showMissionDetails(BuildContext context, Mission mission) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    mission.objective,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusBadge(mission.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'ID: ${mission.id}',
              style: const TextStyle(
                  color: Colors.white38, fontSize: 10, fontFamily: 'Courier'),
            ),
            const SizedBox(height: 16),
            if (mission.notes.isNotEmpty) ...[
              const Text('NOTES',
                  style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...mission.notes.take(3).map((note) => Text(note,
                  style: const TextStyle(color: Colors.white70, fontSize: 12))),
            ] else
              const Text('No notes available for this mission.',
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontStyle: FontStyle.italic)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24)),
                child:
                    const Text('Close', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return Colors.greenAccent;
    if (confidence >= 60) return Colors.yellowAccent;
    if (confidence >= 40) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
