import 'package:flutter/material.dart';

import 'HomePageController.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const controller = HomePageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'List',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
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
      ),
    );
  }
}