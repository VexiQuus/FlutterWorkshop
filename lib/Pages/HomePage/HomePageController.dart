import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _entriesStorageKey = 'journal_entries';

  HomePageSortOption sortOption = HomePageSortOption.nameAscending;
  final List<JournalEntry> entries = [];
  bool isLoading = true;
  String? loadError;
  String? storageError;
  Future<void> _saveQueue = Future<void>.value();
  bool _disposed = false;

  static final List<JournalEntry> _initialEntries = [
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

  Future<void> loadEntries() async {
    isLoading = true;
    loadError = null;
    _notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      final storedEntries = preferences.getString(_entriesStorageKey);

      if (storedEntries == null) {
        entries
          ..clear()
          ..addAll(_initialEntries);
        final saved = await preferences.setString(
          _entriesStorageKey,
          jsonEncode(entries.map((entry) => entry.toJson()).toList()),
        );
        if (!saved) {
          storageError = 'Could not save the initial journal entries.';
        }
      } else {
        final decoded = jsonDecode(storedEntries);
        if (decoded is! List) {
          throw const FormatException('Stored journal entries are not a list.');
        }

        entries
          ..clear()
          ..addAll(
            decoded.map(
              (entry) => JournalEntry.fromJson(
                Map<String, dynamic>.from(entry as Map),
              ),
            ),
          );
      }

      sortEntries();
    } on FormatException catch (error) {
      loadError = 'Could not read saved journal entries: ${error.message}';
    } on TypeError catch (error) {
      loadError = 'Saved journal entries have an invalid format: $error';
    } on Exception catch (error) {
      loadError = 'Could not load journal entries: $error';
    } finally {
      isLoading = false;
      _notifyListeners();
    }
  }

  Future<void> _persistEntries() {
    _saveQueue = _saveQueue.then((_) async {
      try {
        final preferences = await SharedPreferences.getInstance();
        final saved = await preferences.setString(
          _entriesStorageKey,
          jsonEncode(entries.map((entry) => entry.toJson()).toList()),
        );
        storageError = saved
            ? null
            : 'The preferences store rejected the journal data.';
      } on Exception catch (error) {
        storageError = 'Could not save journal entries: $error';
      }
      _notifyListeners();
    });
    return _saveQueue;
  }

  void sortEntries() {
    entries.sort((a, b) {
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
    sortEntries();
    _notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    entries.insert(0, entry);
    sortEntries();
    _notifyListeners();
    await _persistEntries();
  }

  Future<void> updateEntry(
    JournalEntry previousEntry,
    JournalEntry updatedEntry,
  ) async {
    final index = entries.indexOf(previousEntry);
    if (index == -1) {
      return;
    }

    entries[index] = updatedEntry;
    sortEntries();
    _notifyListeners();
    await _persistEntries();
  }

  Future<void> removeEntry(JournalEntry entry) async {
    if (entries.remove(entry)) {
      _notifyListeners();
      await _persistEntries();
    }
  }

  Future<void> openDetail(BuildContext context, JournalEntry entry) async {
    final updatedEntry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute<JournalEntry>(builder: (_) => DetailPage(entry: entry)),
    );

    if (updatedEntry != null && context.mounted) {
      await updateEntry(entry, updatedEntry);
    }
  }

  Future<void> openAdd(BuildContext context) async {
    final entry = await Navigator.of(context).push<JournalEntry>(
      MaterialPageRoute<JournalEntry>(builder: (_) => const AddPage()),
    );

    if (entry != null && context.mounted) {
      await addEntry(entry);
    }
  }

  void openSettings(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
  }

  void _notifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
