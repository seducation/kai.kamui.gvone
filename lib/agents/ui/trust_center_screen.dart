import 'package:flutter/material.dart';
import '../rules/rule_engine.dart';
import '../rules/rule_definitions.dart';
import '../specialized/systems/explainability_engine.dart';
import '../specialized/systems/confidence_drift_monitor.dart';
import '../coordination/reflex_system.dart';

/// Trust & Control Center 🛡️
/// Central hub for monitoring Explainability, Compliance, Confidence, and Safety.
class TrustCenterScreen extends StatefulWidget {
  const TrustCenterScreen({super.key});

  @override
  State<TrustCenterScreen> createState() => _TrustCenterScreenState();
}

class _TrustCenterScreenState extends State<TrustCenterScreen> {
  final RuleEngine _ruleEngine = RuleEngine();
  final ExplainabilityEngine _explainability = ExplainabilityEngine();
  final ConfidenceDriftMonitor _confidenceMonitor = ConfidenceDriftMonitor();
  final ReflexSystem _reflexSystem = ReflexSystem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust & Control Center'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade900, Colors.black],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildComplianceSection(),
            const SizedBox(height: 16),
            _buildSafetyStatusSection(),
            const SizedBox(height: 16),
            _buildConfidenceDriftSection(),
            const SizedBox(height: 16),
            _buildExplainabilitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceSection() {
    return _buildCard(
      title: 'Compliance Profile',
      icon: Icons.verified_user,
      child: Column(
        children: [
          ListTile(
            title: Text(
              _ruleEngine.activeProfile.name.toUpperCase(),
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: const Text('Global behavioral constraints',
                style: TextStyle(color: Colors.white70)),
            trailing: PopupMenuButton<ComplianceProfile>(
              icon: const Icon(Icons.settings, color: Colors.white),
              onSelected: (profile) {
                setState(() {
                  _ruleEngine.setProfile(profile);
                });
              },
              itemBuilder: (context) => ComplianceProfile.values
                  .map((p) => PopupMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyStatusSection() {
    final isFrozen = _reflexSystem.isFrozen;
    return _buildCard(
      title: 'Safety Protocols',
      icon: Icons.security,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Emergency Freeze',
                style: TextStyle(color: Colors.white)),
            subtitle: Text(isFrozen ? 'SYSTEM HALTED' : 'Normal Operation',
                style: TextStyle(
                    color: isFrozen ? Colors.redAccent : Colors.greenAccent)),
            value: isFrozen,
            onChanged: (val) {
              setState(() {
                if (val) {
                  _reflexSystem.freeze();
                } else {
                  _reflexSystem.unfreeze();
                }
              });
            },
            activeThumbColor: Colors.redAccent,
          ),
          const Divider(color: Colors.white24),
          const ListTile(
            leading: Icon(Icons.lock_clock, color: Colors.orangeAccent),
            title: Text('Dual Confirmation',
                style: TextStyle(color: Colors.white)),
            subtitle: Text('Active for high-stakes tasks',
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceDriftSection() {
    // Check drift for the Controller agent (main orchestration)
    final accuracy = _confidenceMonitor.getAccuracy('Controller');
    final drift = 1.0 - accuracy;

    return _buildCard(
      title: 'Confidence Monitor',
      icon: Icons.trending_up,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Optimism Bias (Controller)',
                    style: TextStyle(color: Colors.white)),
                Text('${(drift * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        color: drift > 0.2
                            ? Colors.orangeAccent
                            : Colors.cyanAccent)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: accuracy,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(
                  drift > 0.2 ? Colors.orangeAccent : Colors.cyanAccent),
            ),
            const SizedBox(height: 8),
            Text(
              drift > 0.2
                  ? 'High drift detected: Correction multipliers applied.'
                  : 'Trust levels stable. No significant drift detected.',
              style: TextStyle(
                  color: drift > 0.2 ? Colors.orangeAccent : Colors.white38,
                  fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplainabilitySection() {
    final traces = _explainability.recentTraces;
    return _buildCard(
      title: 'Decision Trace Log',
      icon: Icons.history_edu,
      child: traces.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No decision traces recorded yet.',
                  style: TextStyle(color: Colors.white38)),
            )
          : Column(
              children: traces
                  .take(3)
                  .map((t) => ListTile(
                        title: Text(t.intent,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                        subtitle: Text('Outcome: ${t.finalOutcome}',
                            style: TextStyle(
                                color: t.finalOutcome == 'Blocked'
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                                fontSize: 11)),
                        trailing: Text(
                          '${t.timestamp.hour}:${t.timestamp.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 10),
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Icon(icon, color: Colors.white38, size: 16),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
