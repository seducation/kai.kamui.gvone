import 'package:flutter/material.dart';

class ExtraInfoPane extends StatelessWidget {
  const ExtraInfoPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 48),
            const SizedBox(height: 16),
            Text(
              'Analytics & Extra Info',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'This pane is only visible on large screens (> 1024px). It typically contains metadata or contextual actions.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
