import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Models/JournalEntry.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({super.key, required this.entry, this.onTap});

  final JournalEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context)
        .formatShortDate(entry.createdAt);
    final strings = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  entry.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _photo(context, height: 160),
                ),
                const SizedBox(height: 8),
                Text(entry.note, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(strings.createdOnDate(date), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photo(BuildContext context, {required double height}) {
    final path = entry.imagePath;
    if (path == null || path.isEmpty) {
      return _photoPlaceholder(context, height);
    }

    return Image.file(
      File(path),
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _photoPlaceholder(context, height),
    );
  }

  Widget _photoPlaceholder(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 36,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
