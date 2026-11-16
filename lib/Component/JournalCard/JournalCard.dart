import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({super.key, required this.entry, this.onTap});

  final JournalEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date =
        '${entry.createdAt.day.toString().padLeft(2, '0')}/'
        '${entry.createdAt.month.toString().padLeft(2, '0')}/'
        '${entry.createdAt.year}';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(entry.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(entry.note, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(date, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
