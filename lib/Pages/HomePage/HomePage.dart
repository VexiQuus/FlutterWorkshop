import 'dart:async';

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
    unawaited(_controller.loadEntries());
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
              onPressed: _controller.isLoading || _controller.loadError != null
                  ? null
                  : () => _controller.openAdd(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _controller.loadError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _controller.loadError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => unawaited(_controller.loadEntries()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_controller.storageError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _controller.storageError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                      onDismissed: (_) =>
                          unawaited(_controller.removeEntry(entry)),
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
