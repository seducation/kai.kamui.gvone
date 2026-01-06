import 'message_bus.dart';

/// The Reflex System (Spinal Cord) ⚡
///
/// Reacts faster than the Brain (`Planner`). Intercepts signals and inputs
/// to prevent damage before high-level processing occurs.
///
/// Functions:
/// 1. **Nociception (Pain Sensing)**: Detects dangerous keywords.
/// 2. **Motor Reflex**: Blocks execution of risky actions.
/// 3. **Startle Response**: Instant reaction to rapid failure.
class ReflexSystem {
  static final ReflexSystem _instance = ReflexSystem._internal();
  factory ReflexSystem() => _instance;
  ReflexSystem._internal();

  final MessageBus _bus = messageBus;
  bool _isActive = false;

  // Dangerous keywords that trigger a "Pain" withdrawal reflex
  static const List<String> _dangerSignals = [
    'rm -rf',
    'delete database',
    'drop table',
    'format c:',
    'sudo',
  ];

  void start() {
    if (_isActive) return;
    _isActive = true;
    // We don't subscribe to the bus generally, but we expose a check method
    // that the Controller calls synchronously *before* planning.
  }

  /// The "Dodge" Reflex
  /// Returns TRUE if danger is detected and blocked.
  bool checkReflex(String input) {
    if (!_isActive) return false;

    // Nociception: Check for pain signals
    for (final signal in _dangerSignals) {
      if (input.toLowerCase().contains(signal)) {
        _triggerPainWithdrawal(signal);
        return true; // Blocked!
      }
    }
    return false;
  }

  void _triggerPainWithdrawal(String stimulus) {
    print('⚡ REFLEX ACTIVATED: Withdrawal from dangerous stimulus "$stimulus"');
    // In a real biological system, this would cause immediate muscle contraction
    // Here, we log an error event directly to the bus
    _bus.broadcast(AgentMessage(
      id: 'reflex_${DateTime.now().millisecondsSinceEpoch}',
      from: 'ReflexSystem',
      type: MessageType.error,
      payload: 'Blocked dangerous action: $stimulus',
    ));
  }
}
