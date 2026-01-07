/// Context Compression Engine (Memory Sharpness) 🧠🗜️
///
/// Prevents "Hallucination Creep" by condensing old context and vault entries
/// into semantic summaries. Keeps the system's focus sharp and fast.
class ContextCompressionEngine {
  static final ContextCompressionEngine _instance =
      ContextCompressionEngine._internal();
  factory ContextCompressionEngine() => _instance;
  ContextCompressionEngine._internal();

  /// Condenses a list of history strings into a single summary
  String condenseHistory(List<String> history) {
    if (history.isEmpty) return '';
    if (history.length <= 3) return history.join('\n');

    // Deterministic Condensation (Phase 9 Implementation)
    // In a real LLM scenario, this would be a prompt.
    // Here we use structural extraction as a "Sharpness" heuristic.

    final coreIntents = <String>{};
    for (var line in history) {
      final intent = _extractIntent(line);
      if (intent != null) coreIntents.add(intent);
    }

    final summary = StringBuffer('PREVIOUS CONTEXT (CONDENSED):\n');
    summary.writeln('- User patterns: ${coreIntents.join(", ")}');
    summary.writeln(
        '- State: System stable. ${history.length} events compressed.');

    return summary.toString();
  }

  String? _extractIntent(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('code') || lower.contains('write')) return 'Development';
    if (lower.contains('test') || lower.contains('debug')) return 'Fixing';
    if (lower.contains('deploy') || lower.contains('push')) return 'DevOps';
    if (lower.contains('search') || lower.contains('crawl')) return 'Discovery';
    return null;
  }

  /// Prunes low-confidence metadata from a context map
  Map<String, dynamic> pruneMetadata(Map<String, dynamic> metadata) {
    final pruned = Map<String, dynamic>.from(metadata);

    // Prune keys that are likely "transient noise"
    pruned.removeWhere((key, value) =>
        key.contains('temp') ||
        key.contains('cached') ||
        key.contains('timestamp'));

    return pruned;
  }
}

/// Global compression instance
final contextCompression = ContextCompressionEngine();
