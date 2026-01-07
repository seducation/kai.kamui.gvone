/// Local World Model (Safe, Powerful) 🌐
///
/// Provides a bounded, domain-specific map of the local environment:
/// - Active Projects
/// - Available Tools
/// - System Organs
///
/// This eliminates "discovery lag" by providing instant structural context.
class LocalWorldModel {
  static final LocalWorldModel _instance = LocalWorldModel._internal();
  factory LocalWorldModel() => _instance;
  LocalWorldModel._internal();

  final Map<String, String> _componentMap = {
    'Core': 'lib/agents/core',
    'Coordination': 'lib/agents/coordination',
    'Rules': 'lib/agents/rules',
    'Specialized': 'lib/agents/specialized',
    'UI': 'lib/agents/ui',
    'Vault': 'lib/agents/storage',
  };

  final Map<String, String> _organResponsibility = {
    'Logic': 'Code Writing & Debugging',
    'Memory': 'Vault Storage & Retrieval',
    'Discovery': 'Web Crawling & Analysis',
    'Speech': 'Social Interaction',
    'Volition': 'Autonomous Intent',
  };

  /// Get the path for a core component
  String? getComponentPath(String name) => _componentMap[name];

  /// Get the responsibility of a specific organ
  String? getOrganResponsibility(String name) => _organResponsibility[name];

  /// Returns a summary of the system architecture for zero-lag context
  String getSystemOverview() {
    return "Intelligence OS (Intelli-OS)\n"
        "Architecture: Multi-Agent Tissue (Biological Pattern)\n"
        "Active Organs: Logic, Memory, Discovery, Speech, Volition\n"
        "Layers: Reflex (Safety), Rule (Authority), Mission (Context)";
  }
}

/// Global world model instance
final worldModel = LocalWorldModel();
