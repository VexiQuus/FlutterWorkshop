import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';

enum HomePageSortOption {
  nameAscending,
  nameDescending,
  dateAscending,
  dateDescending,
}

class HomePageController extends ChangeNotifier {
  HomePageSortOption sortOption = HomePageSortOption.nameAscending;

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

  List<JournalEntry> get sortedEntries {
    final sorted = List<JournalEntry>.of(entries);
    sorted.sort((a, b) {
      switch (sortOption) {
        case HomePageSortOption.nameAscending:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case HomePageSortOption.nameDescending:
          return b.title.toLowerCase().compareTo(a.title.toLowerCase());
        case HomePageSortOption.dateAscending:
          return a.createdAt.compareTo(b.createdAt);
        case HomePageSortOption.dateDescending:
          return b.createdAt.compareTo(a.createdAt);
      }
    });
    return sorted;
  }

  String sortOptionLabel(HomePageSortOption option) {
    return switch (option) {
      HomePageSortOption.nameAscending => 'Name (A-Z)',
      HomePageSortOption.nameDescending => 'Name (Z-A)',
      HomePageSortOption.dateAscending => 'Date (oldest first)',
      HomePageSortOption.dateDescending => 'Date (newest first)',
    };
  }

  void setSortOption(HomePageSortOption option) {
    if (sortOption == option) {
      return;
    }

    sortOption = option;
    notifyListeners();
  }

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
