import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('List')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'List',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.openDetail(context),
                  child: const Text('Detail'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.openAdd(context),
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => _controller.openSettings(context),
                  child: const Text('Settings'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final entry in _controller.entries) JournalCard(entry: entry),
          ],
        ),
      ),
    );
  }
}
