import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import 'HomePageController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _entries = [
    JournalEntry(
      title: 'A New Beginning',
      note: 'Started writing in my journal today.',
      createdAt: DateTime(2026, 11, 1),
    ),
    JournalEntry(
      title: 'A Quiet Afternoon',
      note: 'Enjoyed a peaceful walk and some time to reflect.',
      createdAt: DateTime(2026, 11, 2),
    ),
    JournalEntry(
      title: 'Something to Remember',
      note: 'Small moments can make an ordinary day special.',
      createdAt: DateTime(2026, 11, 3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const controller = HomePageController();

    return Scaffold(
      appBar: AppBar(title: const Text('List')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('List', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 16),
          for (final entry in _entries) JournalCard(entry: entry),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.openDetail(context),
            child: const Text('Detail'),
          ),
          ElevatedButton(
            onPressed: () => controller.openAdd(context),
            child: const Text('Add'),
          ),
          ElevatedButton(
            onPressed: () => controller.openSettings(context),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
