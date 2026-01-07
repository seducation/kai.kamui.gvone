/// Tracks "Confidence Inflation" in AI agents.
/// If an agent is repeatedly confident but fails, it triggers a cooldown.
class ConfidenceDriftMonitor {
  static final ConfidenceDriftMonitor _instance =
      ConfidenceDriftMonitor._internal();
  factory ConfidenceDriftMonitor() => _instance;
  ConfidenceDriftMonitor._internal();

  final Map<String, List<DriftEntry>> _driftHistory = {};

  /// Records a confidence level vs the actual success of the outcome
  void recordOutcome(
      String agentName, double predictedConfidence, bool success) {
    final history = _driftHistory.putIfAbsent(agentName, () => []);
    history.add(DriftEntry(
      confidence: predictedConfidence,
      success: success,
      timestamp: DateTime.now(),
    ));

    // Keep last 20 outcomes
    if (history.length > 20) {
      history.removeAt(0);
    }
  }

  /// Calculates the "Confidence Accuracy" (0.0 to 1.0)
  /// If 1.0, the agent is honest.
  /// If low, the agent is "Overconfident" (Optimism Bias).
  double getAccuracy(String agentName) {
    final history = _driftHistory[agentName];
    if (history == null || history.isEmpty) {
      return 1.0;
    }

    double weightedError = 0.0;
    for (var entry in history) {
      if (!entry.success) {
        // Punish high confidence on failure (The Dunning-Kruger penalty)
        weightedError += entry.confidence;
      }
    }

    // Return a score where 1.0 is no overconfidence drift
    return (1.0 - (weightedError / history.length)).clamp(0.1, 1.0);
  }

  /// Suggests a confidence multiplier for this agent
  /// Used by PlannerAgent to downgrade overconfident agents
  double getCorrectionMultiplier(String agentName) {
    final accuracy = getAccuracy(agentName);
    if (accuracy < 0.7) {
      return 0.5; // Heavy throttle
    }
    if (accuracy < 0.9) {
      return 0.8; // Minor downgrade
    }
    return 1.0; // Trust remains intact
  }
}

class DriftEntry {
  final double confidence;
  final bool success;
  final DateTime timestamp;

  DriftEntry(
      {required this.confidence,
      required this.success,
      required this.timestamp});
}
