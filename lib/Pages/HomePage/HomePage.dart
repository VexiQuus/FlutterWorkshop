import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import 'HomePageController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          for (final entry in HomePageController.entries)
            JournalCard(entry: entry),
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
