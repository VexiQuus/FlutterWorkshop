import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/JournalEntry.dart';

class SettingsPageController {
  const SettingsPageController();

  static const _entriesStorageKey = 'journal_entries';

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<int> localStorageSizeBytes() async {
    final preferences = await SharedPreferences.getInstance();
    var totalBytes = 0;
    final storedEntries = preferences.getString(_entriesStorageKey);
    final imagePaths = <String>{};

    if (storedEntries != null) {
      totalBytes += _storedStringSize(_entriesStorageKey, storedEntries);
      final decodedEntries = jsonDecode(storedEntries);
      if (decodedEntries is! List) {
        throw const FormatException('Stored journal entries are not a list.');
      }

      for (final decodedEntry in decodedEntries) {
        if (decodedEntry is! Map) {
          throw const FormatException('Stored journal entry is not an object.');
        }
        final entry = JournalEntry.fromJson(
          Map<String, dynamic>.from(decodedEntry),
        );
        final imagePath = entry.imagePath;
        if (imagePath != null && imagePath.isNotEmpty) {
          imagePaths.add(imagePath);
        }
      }
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    await for (final entity in documentsDirectory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File) {
        final filePath = entity.absolute.path;
        final fileName = entity.uri.pathSegments.last;
        if (fileName.startsWith('journal_') || imagePaths.contains(filePath)) {
          totalBytes += await entity.length();
        }
      }
    }

    return totalBytes;
  }

  int _storedStringSize(String key, String value) =>
      utf8.encode(key).length + utf8.encode(value).length;
}
