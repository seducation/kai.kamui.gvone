class HandleSystem {
  /// Normalizes the handle by converting to lowercase, removing common
  /// separators, and replacing lookalike characters.
  static String normalize(String handle) {
    String normalized = handle.toLowerCase();

    // Remove dots and underscores
    normalized = normalized.replaceAll(RegExp(r'[._]'), '');

    // Replace lookalikes: 0 -> o, 1 -> l, 5 -> s
    normalized = normalized
        .replaceAll('0', 'o')
        .replaceAll('1', 'l')
        .replaceAll('5', 's');

    return normalized;
  }

  /// Generates a fingerprint by collapsing duplicate consecutive letters
  /// from a normalized handle.
  static String generateFingerprint(String handle) {
    final normalized = normalize(handle);
    if (normalized.isEmpty) return '';

    final buffer = StringBuffer();
    buffer.write(normalized[0]);

    for (int i = 1; i < normalized.length; i++) {
      if (normalized[i] != normalized[i - 1]) {
        buffer.write(normalized[i]);
      }
    }

    return buffer.toString();
  }

  /// Calculates if a handle change is allowed based on the cooldown period.
  static bool canChangeHandle(
    String? lastHandleChangeAtISO, {
    int cooldownDays = 7,
  }) {
    if (lastHandleChangeAtISO == null || lastHandleChangeAtISO.isEmpty) {
      return true;
    }

    try {
      final lastChange = DateTime.parse(lastHandleChangeAtISO);
      final now = DateTime.now();
      final difference = now.difference(lastChange);

      return difference.inDays >= cooldownDays;
    } catch (e) {
      // If parsing fails, allow change for safety but log it
      return true;
    }
  }

  /// Returns the remaining cooldown duration.
  static Duration remainingCooldown(
    String? lastHandleChangeAtISO, {
    int cooldownDays = 7,
  }) {
    if (lastHandleChangeAtISO == null || lastHandleChangeAtISO.isEmpty) {
      return Duration.zero;
    }

    try {
      final lastChange = DateTime.parse(lastHandleChangeAtISO);
      final now = DateTime.now();
      final expiry = lastChange.add(Duration(days: cooldownDays));

      if (now.isAfter(expiry)) {
        return Duration.zero;
      }

      return expiry.difference(now);
    } catch (e) {
      return Duration.zero;
    }
  }
}
