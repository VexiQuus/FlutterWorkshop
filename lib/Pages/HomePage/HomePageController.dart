import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';

class HomePageController extends ChangeNotifier {
  final List<JournalEntry> entries = [
    JournalEntry(
      title: 'A New Beginning',
      note: 'Started writing in my journal today.',
      createdAt: DateTime(2026, 11, 1),
    ),
    JournalEntry(
      title: 'A Quiet Afternoon',
      note: 'Enjoyed a peaceful walk and some time to reflect.',
      createdAt: DateTime(2026, 11, 2),
    ),
    JournalEntry(
      title: 'Something to Remember',
      note: 'Small moments can make an ordinary day special.',
      createdAt: DateTime(2026, 11, 3),
    ),
  ];

  void openDetail(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const DetailPage()));
  }

  Future<void> openAdd(BuildContext context) async {
    final entry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute<JournalEntry>(builder: (_) => const AddPage()),
    );

    if (entry != null && context.mounted) {
      entries.insert(0, entry);
      notifyListeners();
    }
  }

  void openSettings(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
  }
}
