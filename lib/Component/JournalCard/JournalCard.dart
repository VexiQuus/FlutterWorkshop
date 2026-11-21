import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import '../../Models/JournalEntry.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.entry,
    this.onTap,
    this.isSelected = false,
  });

  final JournalEntry entry;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final date = MaterialLocalizations.of(context)
        .formatShortDate(entry.createdAt);
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: isSelected
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.colorScheme.primary, width: 2),
              )
            : null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _photo(context, size: 48),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        entry.note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        strings.createdOnDate(date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photo(BuildContext context, {required double size}) {
    final path = entry.imagePath;
    if (path == null || path.isEmpty) {
      return _photoPlaceholder(context, size);
    }

    return Image.file(
      File(path),
      height: size,
      width: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _photoPlaceholder(context, size),
    );
  }

  Widget _photoPlaceholder(BuildContext context, double size) {
    return Container(
      height: size,
      width: size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 24,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
