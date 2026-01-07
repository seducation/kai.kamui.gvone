/// Circadian Rhythm Tracker (Temporal Memory) 🕰️
///
/// Tracks user patterns across time to anticipate needs based on
/// temporal context (e.g., "Monday Morning" vs "Friday Evening").
class CircadianRhythmTracker {
  static final CircadianRhythmTracker _instance =
      CircadianRhythmTracker._internal();
  factory CircadianRhythmTracker() => _instance;
  CircadianRhythmTracker._internal();

  // Map: DayOfWeek (1-7) -> Hour (0-23) -> List of Commands
  final Map<int, Map<int, List<String>>> _temporalMap = {};

  /// Record an action with its timestamp
  void recordAction(String action) {
    final now = DateTime.now();
    final day = now.weekday;
    final hour = now.hour;

    final hourMap = _temporalMap.putIfAbsent(day, () => {});
    final actions = hourMap.putIfAbsent(hour, () => []);

    actions.add(action);
    if (actions.length > 20) {
      actions.removeAt(0); // Keep last 20 actions per hour slot
    }
  }

  /// Get likely actions for the current or upcoming time slot
  List<String> getLikelyActions({bool lookAhead = false}) {
    final now = DateTime.now();
    var day = now.weekday;
    var hour = now.hour;

    if (lookAhead) {
      hour += 1;
      if (hour > 23) {
        hour = 0;
        day += 1;
        if (day > 7) day = 1;
      }
    }

    final hourMap = _temporalMap[day];
    if (hourMap == null) return [];

    final actions = hourMap[hour];
    if (actions == null || actions.isEmpty) return [];

    // Return unique high-frequency actions
    // (Simple frequency count for now)
    final frequency = <String, int>{};
    for (var action in actions) {
      frequency[action] = (frequency[action] ?? 0) + 1;
    }

    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).map((e) => e.key).toList();
  }
}
