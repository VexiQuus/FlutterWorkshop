import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Models/JournalEntry.dart';
import 'package:flutterworkshop/Pages/HomePage/HomePageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'loads saved entries and persists deletions across controller reloads',
    () async {
      SharedPreferences.setMockInitialValues({
        'journal_entries': jsonEncode([
          {
            'title': 'Saved entry',
            'note': 'Persisted note',
            'createdAt': '2026-11-17T09:00:00.000',
            'imagePath': '/saved/photo.jpg',
          },
          {
            'title': 'Entry to delete',
            'note': '',
            'createdAt': '2026-11-16T09:00:00.000',
            'imagePath': null,
          },
        ]),
      });

      final controller = HomePageController();
      await controller.loadEntries();

      expect(controller.entries, hasLength(2));
      final savedEntry = controller.entries.firstWhere(
        (entry) => entry.title == 'Saved entry',
      );
      expect(savedEntry.imagePath, '/saved/photo.jpg');

      final addedEntry = JournalEntry(
        title: 'Added entry',
        note: 'New note',
        createdAt: DateTime(2026, 11, 18),
      );
      await controller.addEntry(addedEntry);

      final updatedEntry = JournalEntry(
        title: 'Updated entry',
        note: 'Updated note',
        createdAt: savedEntry.createdAt,
        imagePath: '/saved/updated-photo.jpg',
      );
      await controller.updateEntry(savedEntry, updatedEntry);

      final entryToDelete = controller.entries.firstWhere(
        (entry) => entry.title == 'Entry to delete',
      );
      await controller.removeEntry(entryToDelete);
      controller.dispose();

      final reloadedController = HomePageController();
      await reloadedController.loadEntries();

      expect(reloadedController.entries, hasLength(2));
      expect(
        reloadedController.entries.map((entry) => entry.title),
        containsAll(['Added entry', 'Updated entry']),
      );
      final reloadedUpdatedEntry = reloadedController.entries.firstWhere(
        (entry) => entry.title == 'Updated entry',
      );
      expect(reloadedUpdatedEntry.note, 'Updated note');
      expect(reloadedUpdatedEntry.imagePath, '/saved/updated-photo.jpg');
      reloadedController.dispose();
    },
  );
}
