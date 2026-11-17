import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class DetailPageController {
  const DetailPageController();

  void goBack(BuildContext context, JournalEntry entry) {
    Navigator.of(context).pop<JournalEntry>(entry);
  }
}
