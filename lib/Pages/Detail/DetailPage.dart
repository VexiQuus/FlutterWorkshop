import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'DetailPageController.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    const controller = DetailPageController();
    final date =
        '${entry.createdAt.day.toString().padLeft(2, '0')}/'
        '${entry.createdAt.month.toString().padLeft(2, '0')}/'
        '${entry.createdAt.year}';

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: Text(entry.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AspectRatio(
            aspectRatio: 0.7,
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      entry.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            entry.note,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
