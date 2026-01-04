import 'package:flutter/material.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, size: 100, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Subscription Plans',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Unlock premium features with our subscription plans:\n\n'
                '• More TV Profile slots\n'
                '• Enhanced RSS feed capabilities\n'
                '• Priority support\n'
                '• Advanced analytics',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
