import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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

enum HomePageErrorCode {
  initialEntriesSave,
  storedEntriesNotList,
  readSavedEntries,
  invalidSavedEntries,
  loadEntries,
  preferencesRejectedEntries,
  saveEntries,
}

class HomePageError {
  const HomePageError(this.code, {this.details});

  final HomePageErrorCode code;
  final String? details;
}

class HomePageController extends ChangeNotifier {
  static const _entriesStorageKey = 'journal_entries';

  HomePageSortOption sortOption = HomePageSortOption.nameAscending;
  final List<JournalEntry> entries = [];
  bool isLoading = true;
  HomePageError? loadError;
  HomePageError? storageError;
  Future<void> _saveQueue = Future<void>.value();
  bool _disposed = false;

  Future<void> loadEntries({required List<JournalEntry> initialEntries}) async {
    isLoading = true;
    loadError = null;
    _notifyListeners();

    try {
      final preferences = await SharedPreferences.getInstance();
      final storedEntries = preferences.getString(_entriesStorageKey);

      if (storedEntries == null) {
        entries
          ..clear()
          ..addAll(initialEntries);
        final saved = await preferences.setString(
          _entriesStorageKey,
          jsonEncode(entries.map((entry) => entry.toJson()).toList()),
        );
        if (!saved) {
          storageError = const HomePageError(
            HomePageErrorCode.initialEntriesSave,
          );
        }
      } else {
        final decoded = jsonDecode(storedEntries);
        if (decoded is! List) {
          throw const FormatException('stored_entries_not_list');
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
      loadError = error.message == 'stored_entries_not_list'
          ? const HomePageError(HomePageErrorCode.storedEntriesNotList)
          : HomePageError(
              HomePageErrorCode.readSavedEntries,
              details: error.message,
            );
    } on TypeError catch (error) {
      loadError = HomePageError(
        HomePageErrorCode.invalidSavedEntries,
        details: error.toString(),
      );
    } on Exception catch (error) {
      loadError = HomePageError(
        HomePageErrorCode.loadEntries,
        details: error.toString(),
      );
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
            : const HomePageError(HomePageErrorCode.preferencesRejectedEntries);
      } on Exception catch (error) {
        storageError = HomePageError(
          HomePageErrorCode.saveEntries,
          details: error.toString(),
        );
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

  Future<void> clearAllEntriesAndPhotos() async {
    await _saveQueue;

    final preferences = await SharedPreferences.getInstance();
    final imagePaths = entries
        .map((entry) => entry.imagePath)
        .whereType<String>()
        .where((path) => path.isNotEmpty)
        .toSet();

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final photoFiles = <String, File>{};
    await for (final entity in documentsDirectory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        final filePath = entity.absolute.path;
        final fileName = entity.uri.pathSegments.last;
        if (fileName.startsWith('journal_') || imagePaths.contains(filePath)) {
          photoFiles[filePath] = entity;
        }
      }
    }

    final saved = await preferences.setString(_entriesStorageKey, '[]');
    if (!saved) {
      throw Exception('The preferences store rejected the journal clear.');
    }

    entries.clear();
    loadError = null;
    isLoading = false;
    storageError = null;
    _notifyListeners();

    for (final file in photoFiles.values) {
      if (await file.exists()) {
        await file.delete();
      }
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

  void openSettings(
    BuildContext context, {
    required Future<bool> Function(Locale locale) onLocaleChanged,
    required Future<void> Function() onClearAll,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(
          onLocaleChanged: onLocaleChanged,
          onClearAll: onClearAll,
        ),
      ),
    );
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
