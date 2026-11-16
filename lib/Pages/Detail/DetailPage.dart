import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'DetailPageController.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    const controller = DetailPageController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: Text(entry.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                entry.title,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                entry.note,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
