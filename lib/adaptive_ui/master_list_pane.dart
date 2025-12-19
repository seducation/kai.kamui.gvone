import 'package:flutter/material.dart';

class MasterListPane extends StatelessWidget {
  final List<String> items;
  final int? selectedId;
  final ValueChanged<int> onItemSelected;

  const MasterListPane({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final isSelected = selectedId == index;
        return ListTile(
          selected: isSelected,
          selectedTileColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(items[index]),
          subtitle: const Text('Tap to view details'),
          onTap: () => onItemSelected(index),
          trailing: isSelected ? const Icon(Icons.chevron_right) : null,
        );
      },
    );
  }
}
