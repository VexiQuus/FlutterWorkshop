import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Models/JournalEntry.dart';

class JournalDetailContent extends StatelessWidget {
  const JournalDetailContent({
    super.key,
    required this.entry,
    this.photoHeight = 140,
  });

  final JournalEntry entry;
  final double photoHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = MaterialLocalizations.of(context)
        .formatShortDate(entry.createdAt);
    final strings = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Text(
            strings.createdOnDate(date),
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          entry.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _photo(context),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                entry.note,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _photo(BuildContext context) {
    final path = entry.imagePath;
    if (path == null || path.isEmpty) {
      return _photoPlaceholder(context);
    }

    return Image.file(
      File(path),
      height: photoHeight,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _photoPlaceholder(context),
    );
  }

  Widget _photoPlaceholder(BuildContext context) {
    return Container(
      height: photoHeight,
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
