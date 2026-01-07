/// Agent Reliability Scorecard (Dynamic Profiling) 📊
///
/// Tracks the performance of an individual agent to influence
/// task routing and priority scheduling.
///
/// Metrics:
/// - Success Rate (Reliability)
/// - Average Latency (Efficiency)
/// - Failure Streak (Risk)
class AgentScorecard {
  final String agentName;

  int _successCount = 0;
  int _failureCount = 0;
  int _totalTasks = 0;

  /// Consecutive failures
  int _failureStreak = 0;

  /// Running average of execution time
  Duration _avgLatency = const Duration(milliseconds: 0);

  DateTime? lastActive;

  /// Tool usage statistics (Tool Name -> Count)
  final Map<String, int> _toolUsage = {};

  /// Error bias tracking (Error Type -> Count)
  final Map<String, int> _errorBiases = {};

  AgentScorecard(this.agentName);

  /// Record a task execution result
  void recordResult({
    required bool success,
    Duration? latency,
    String? toolName,
    String? errorType,
  }) {
    _totalTasks++;
    lastActive = DateTime.now();

    if (success) {
      _successCount++;
      _failureStreak = 0;
    } else {
      _failureCount++;
      _failureStreak++;
    }

    if (latency != null) {
      if (_avgLatency.inMilliseconds == 0) {
        _avgLatency = latency;
      } else {
        // Simple moving average (weighted towards recent)
        final oldMs = _avgLatency.inMilliseconds;
        final newMs = latency.inMilliseconds;
        _avgLatency =
            Duration(milliseconds: ((oldMs * 0.8) + (newMs * 0.2)).round());
      }
    }

    if (toolName != null) {
      _toolUsage[toolName] = (_toolUsage[toolName] ?? 0) + 1;
    }

    if (errorType != null) {
      _errorBiases[errorType] = (_errorBiases[errorType] ?? 0) + 1;
    }
  }

  /// Get the reliability score (0.0 - 1.0)
  ///
  /// Penalizes failure streaks heavily.
  double get reliabilityScore {
    if (_totalTasks == 0) return 1.0; // Assume innocent until proven guilty

    final rawRate = _successCount / _totalTasks;

    // Streak penalty: 10% penalty per consecutive failure
    final penalty = _failureStreak * 0.1;

    return (rawRate - penalty).clamp(0.0, 1.0);
  }

  /// Get efficiency description
  String get efficiencyRating {
    if (_avgLatency.inMilliseconds < 1000) return '⚡ Fast';
    if (_avgLatency.inMilliseconds < 5000) return '🟢 Normal';
    if (_avgLatency.inMilliseconds < 15000) return '🟠 Slow';
    return '🔴 Sluggish';
  }

  /// Get most used tools
  List<MapEntry<String, int>> get topTools {
    final sorted = _toolUsage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  /// Get problematic error patterns
  List<MapEntry<String, int>> get commonErrors {
    final sorted = _errorBiases.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  Map<String, dynamic> toJson() => {
        'agent': agentName,
        'success': _successCount,
        'failure': _failureCount,
        'streak': _failureStreak,
        'reliability': reliabilityScore,
        'avgLatencyMs': _avgLatency.inMilliseconds,
        'topTools': topTools.map((e) => '${e.key}:${e.value}').toList(),
        'commonErrors': commonErrors.map((e) => '${e.key}:${e.value}').toList(),
      };
}
