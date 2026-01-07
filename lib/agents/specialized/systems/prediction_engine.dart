/// Prediction Engine (Strategic Anticipation) 🔮
///
/// Tracks user command patterns to preload agents and tools.
/// Eliminates "loading" perception by being ready before the user asks.
class PredictionEngine {
  /// Intent Anticipation Graph (A -> B -> C)
  final Map<String, Map<String, double>> _sequenceGraph = {};

  /// Recent command window for N-gram tracking
  final List<String> _recentCommands = [];

  /// Max history for local context
  static const int maxHistory = 50;

  /// Record a command and strengthen the anticipation graph
  void recordCommand(String command) {
    final cmd = command.toLowerCase();

    // 1. Update Graph (Temporal Strengthening)
    if (_recentCommands.isNotEmpty) {
      final last = _recentCommands.last;
      _strengthenLink(last, cmd);

      // Look back two steps for deeper anticipation (A -> C)
      if (_recentCommands.length >= 2) {
        final previous = _recentCommands[_recentCommands.length - 2];
        _strengthenLink(previous, cmd, weight: 0.5); // Indirect link
      }
    }

    // 2. Update Window
    _recentCommands.add(cmd);
    if (_recentCommands.length > maxHistory) _recentCommands.removeAt(0);

    // 3. Apply Temporal Decay (Sharpening the focus on recent behavior)
    _applyDecay();
  }

  void _strengthenLink(String from, String to, {double weight = 1.0}) {
    final targets = _sequenceGraph.putIfAbsent(from, () => {});
    targets[to] = (targets[to] ?? 0.0) + weight;
  }

  void _applyDecay() {
    // Every 10 commands, slightly decay old patterns to favor current workflows
    if (_recentCommands.length % 10 == 0) {
      for (final targets in _sequenceGraph.values) {
        targets.updateAll((key, val) => val * 0.95);
      }
    }
  }

  /// Predict next likely agents based on current intent graph
  List<String> predictNextAgents() {
    if (_recentCommands.isEmpty) return [];

    final lastCmd = _recentCommands.last;
    final targets = _sequenceGraph[lastCmd];

    if (targets == null || targets.isEmpty) {
      // Fallback to keyword matching if no graph data
      return [_mapCommandToAgent(lastCmd)].whereType<String>().toList();
    }

    // Sort by graph weight (Probability)
    final sorted = targets.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final predictions = <String>{};
    for (final entry in sorted.take(3)) {
      // Top 3 anticipated next steps
      final agent = _mapCommandToAgent(entry.key);
      if (agent != null) predictions.add(agent);
    }

    return predictions.toList();
  }

  String? _mapCommandToAgent(String command) {
    if (command.contains('code') || command.contains('write')) {
      return 'CodeWriter';
    }
    if (command.contains('crawl') || command.contains('web')) {
      return 'WebCrawler';
    }
    if (command.contains('test') || command.contains('debug')) {
      return 'CodeDebugger';
    }
    if (command.contains('save') || command.contains('store')) {
      return 'StorageAgent';
    }
    if (command.contains('social') || command.contains('post')) {
      return 'SocialAgent';
    }
    return null;
  }
}
