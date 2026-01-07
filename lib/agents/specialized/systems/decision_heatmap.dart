import 'explainability_engine.dart';

/// Heatmap Data Model
class DecisionHeatmap {
  final Map<String, double> influenceMap; // Component -> Weight (0.0 - 1.0)
  final String dominantFactor;

  DecisionHeatmap({
    required this.influenceMap,
    required this.dominantFactor,
  });
}

/// Generates heatmaps from Decision Traces
class DecisionHeatmapGenerator {
  static final DecisionHeatmapGenerator _instance =
      DecisionHeatmapGenerator._internal();
  factory DecisionHeatmapGenerator() => _instance;
  DecisionHeatmapGenerator._internal();

  /// Generate a heatmap for a given trace
  DecisionHeatmap generate(DecisionTrace trace) {
    final influence = <String, double>{};

    // 1. Aggregate accumulation of absolute weights
    for (final factor in trace.factors) {
      final key = factor.source;
      final magnitude = factor.weight.abs();
      influence[key] = (influence[key] ?? 0.0) + magnitude;
    }

    // 2. Normalize to percentages (0.0 - 1.0)
    final totalWeight = influence.values.fold(0.0, (sum, v) => sum + v);
    if (totalWeight > 0) {
      influence.updateAll((key, val) => val / totalWeight);
    }

    // 3. Find dominant factor
    String dominant = 'None';
    double maxVal = -1.0;
    influence.forEach((key, val) {
      if (val > maxVal) {
        maxVal = val;
        dominant = key;
      }
    });

    return DecisionHeatmap(
      influenceMap: influence,
      dominantFactor: dominant,
    );
  }
}
