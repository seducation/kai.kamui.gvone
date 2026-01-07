import 'package:flutter/material.dart';

/// Risk Forecast Widget 🌦️
///
/// Displays the "weather report" for a plan (Success Probability).
/// Used in Plan Approval screens to warn users about flaky agents.
class RiskForecastWidget extends StatelessWidget {
  /// Overall probability of success (0.0 - 1.0)
  final double successProbability;

  /// List of risk factors (e.g., "WebCrawler is unstable")
  final List<String> riskFactors;

  const RiskForecastWidget({
    super.key,
    required this.successProbability,
    this.riskFactors = const [],
  });

  @override
  Widget build(BuildContext context) {
    final status = _getStatus(successProbability);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                status.icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Forecast',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${(successProbability * 100).toInt()}% Success Probability',
                    style: TextStyle(
                      color: status.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (riskFactors.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF2D2D44)),
            const SizedBox(height: 8),
            ...riskFactors.map((risk) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orange, size: 14),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          risk,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  _RiskStatus _getStatus(double prob) {
    if (prob >= 0.9) {
      return _RiskStatus(
        color: const Color(0xFF48BB78),
        icon: '☀️', // Sunny
        label: 'Excellent',
      );
    } else if (prob >= 0.7) {
      return _RiskStatus(
        color: const Color(0xFFF6E05E),
        icon: '⛅', // Partly Cloudy
        label: 'Stable',
      );
    } else if (prob >= 0.5) {
      return _RiskStatus(
        color: Colors.orange,
        icon: '🌧️', // Rainy
        label: 'Unstable',
      );
    } else {
      return _RiskStatus(
        color: Colors.red,
        icon: '⛈️', // Stormy
        label: 'Critical',
      );
    }
  }
}

class _RiskStatus {
  final Color color;
  final String icon;
  final String label;

  _RiskStatus({
    required this.color,
    required this.icon,
    required this.label,
  });
}
