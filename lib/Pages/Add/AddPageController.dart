import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class AddPageController {
  const AddPageController();

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  void save(
    BuildContext context, {
    required String title,
    required String note,
  }) {
    final entry = JournalEntry(
      title: title,
      note: note,
      createdAt: DateTime.now(),
    );
    Navigator.of(context).pop<JournalEntry>(entry);
  }
}
