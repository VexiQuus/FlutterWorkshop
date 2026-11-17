import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class AddPageController {
  const AddPageController();

  void save(
    BuildContext context, {
    required String title,
    required String note,
    JournalEntry? existingEntry,
  }) {
    final entry = JournalEntry(
      title: title,
      note: note,
      createdAt: existingEntry?.createdAt ?? DateTime.now(),
    );
    Navigator.of(context).pop<JournalEntry>(entry);
  }
}
