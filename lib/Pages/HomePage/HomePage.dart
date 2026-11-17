import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _controller.sortEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool?> _confirmDelete(JournalEntry entry) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete journal entry?'),
        content: Text('Delete "${entry.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Settings',
            onPressed: () => _controller.openSettings(context),
            icon: const Icon(Icons.settings),
          ),
          title: const Text('List'),
          actions: [
            IconButton(
              tooltip: 'Add journal entry',
              onPressed: () => _controller.openAdd(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'List',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Journal entries',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DropdownButton<HomePageSortOption>(
                  value: _controller.sortOption,
                  onChanged: (option) {
                    if (option != null) {
                      _controller.setSortOption(option);
                    }
                  },
                  items: [
                    for (final option in HomePageSortOption.values)
                      DropdownMenuItem(
                        value: option,
                        child: Text(_controller.sortOptionLabel(option)),
                      ),
                  ],
                ),
              ],
            ),
            for (final entry in _controller.entries)
              Dismissible(
                key: ObjectKey(entry),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmDelete(entry),
                onDismissed: (_) => _controller.removeEntry(entry),
                child: JournalCard(
                  entry: entry,
                  onTap: () => _controller.openDetail(context, entry),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
