import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingThemeScreen extends StatefulWidget {
  const SettingThemeScreen({super.key});

  @override
  State<SettingThemeScreen> createState() => _SettingThemeScreenState();
}

enum ThemeOptions { light, dark, system }

class _SettingThemeScreenState extends State<SettingThemeScreen> {
  ThemeOptions _selectedTheme = ThemeOptions.system;
  bool _isScheduled = false;
  TimeOfDay _startTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _selectTime(BuildContext context, {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeSection(),
          const SizedBox(height: 24),
          _buildAppIconSection(),
          const SizedBox(height: 24),
          _buildScheduleSection(),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SegmentedButton<ThemeOptions>(
              segments: const [
                ButtonSegment(value: ThemeOptions.light, label: Text('Light')),
                ButtonSegment(value: ThemeOptions.dark, label: Text('Dark')),
                ButtonSegment(value: ThemeOptions.system, label: Text('System')),
              ],
              selected: {_selectedTheme},
              onSelectionChanged: (Set<ThemeOptions> newSelection) {
                setState(() {
                  _selectedTheme = newSelection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                selectedBackgroundColor: Colors.blue,
                selectedForegroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIconSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        title: const Text('Change app icon'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to app icon selection screen
        },
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          ListTile(
            title: const Text('Schedule'),
            trailing: Switch(
              value: _isScheduled,
              onChanged: (bool value) {
                setState(() {
                  _isScheduled = value;
                });
              },
            ),
          ),
          if (_isScheduled)
            Column(
              children: [
                ListTile(
                  title: const Text('Start time'),
                  trailing: Text(_startTime.format(context)),
                  onTap: () => _selectTime(context, isStart: true),
                ),
                ListTile(
                  title: const Text('End time'),
                  trailing: Text(_endTime.format(context)),
                  onTap: () => _selectTime(context, isStart: false),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
