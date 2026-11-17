import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Pages/HomePage/HomePageController.dart';
import 'package:flutterworkshop/Pages/Settings/SettingsPageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'clears journal entries and their photos but preserves app settings',
    () async {
      final documentsDirectory = await Directory.systemTemp.createTemp(
        'journal_clear_test',
      );
      addTearDown(() => documentsDirectory.delete(recursive: true));

      const pathProviderChannel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return documentsDirectory.path;
            }
            throw MissingPluginException('No mock for ${methodCall.method}');
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(pathProviderChannel, null),
      );

      final photo = File('${documentsDirectory.path}\\journal_photo.jpg');
      await photo.writeAsBytes([1, 2, 3, 4]);
      final orphanedPhoto = File(
        '${documentsDirectory.path}\\journal_orphaned.jpg',
      );
      await orphanedPhoto.writeAsBytes([5, 6, 7]);
      final unrelatedFile = File('${documentsDirectory.path}\\keep.txt');
      await unrelatedFile.writeAsString('keep');

      SharedPreferences.setMockInitialValues({
        'journal_entries': jsonEncode([
          {
            'title': 'Entry',
            'note': 'Note',
            'createdAt': '2026-11-17T09:00:00.000',
            'imagePath': photo.path,
          },
        ]),
        'app_locale': 'zh_TW',
      });

      final homeController = HomePageController();
      await homeController.loadEntries(initialEntries: []);
      await homeController.clearAllEntriesAndPhotos();

      expect(homeController.entries, isEmpty);
      expect(await photo.exists(), isFalse);
      expect(await orphanedPhoto.exists(), isFalse);
      expect(await unrelatedFile.exists(), isTrue);

      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString('journal_entries'), '[]');
      expect(preferences.getString('app_locale'), 'zh_TW');

      const settingsController = SettingsPageController();
      final sizeBytes = await settingsController.localStorageSizeBytes();
      expect((sizeBytes / 1024).round(), 0);

      homeController.dispose();
    },
  );
}
