import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class AddPageController {
  const AddPageController();

  void save(
    BuildContext context, {
    required String title,
    required String note,
    JournalEntry? existingEntry,
    String? imagePath,
  }) {
    final entry = JournalEntry(
      title: title,
      note: note,
      createdAt: existingEntry?.createdAt ?? DateTime.now(),
      imagePath: imagePath ?? existingEntry?.imagePath,
    );
    Navigator.of(context).pop<JournalEntry>(entry);
  }
}
