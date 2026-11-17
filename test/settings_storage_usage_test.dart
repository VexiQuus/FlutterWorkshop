import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Pages/Settings/SettingsPageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns zero when no app data is stored', () async {
    final directory = await Directory.systemTemp.createTemp(
      'empty_journal_storage_test',
    );
    addTearDown(() => directory.delete(recursive: true));
    const pathProviderChannel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return directory.path;
          }
          throw MissingPluginException('No mock for ${methodCall.method}');
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pathProviderChannel, null),
    );
    SharedPreferences.setMockInitialValues({});
    const controller = SettingsPageController();

    expect(await controller.localStorageSizeBytes(), 0);
  });

  test(
    'includes journal data and attached photos but not locale preferences',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'journal_storage_usage_test',
      );
      addTearDown(() => directory.delete(recursive: true));

      final imageFile = File('${directory.path}\\journal_photo.jpg');
      final imageBytes = Uint8List.fromList([1, 2, 3, 4]);
      await imageFile.writeAsBytes(imageBytes);
      final orphanedPhoto = File('${directory.path}\\journal_orphaned.jpg');
      final orphanedPhotoBytes = Uint8List.fromList([5, 6, 7]);
      await orphanedPhoto.writeAsBytes(orphanedPhotoBytes);
      const pathProviderChannel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return directory.path;
            }
            throw MissingPluginException('No mock for ${methodCall.method}');
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(pathProviderChannel, null),
      );
      final storedEntries = jsonEncode([
        {
          'title': 'Entry',
          'note': 'Note',
          'createdAt': '2026-11-17T09:00:00.000',
          'imagePath': imageFile.path,
        },
      ]);
      SharedPreferences.setMockInitialValues({
        'journal_entries': storedEntries,
        'app_locale': 'zh_TW',
      });

      const controller = SettingsPageController();
      final expectedBytes =
          utf8.encode('journal_entries').length +
          utf8.encode(storedEntries).length +
          imageBytes.length +
          orphanedPhotoBytes.length;

      expect(await controller.localStorageSizeBytes(), expectedBytes);
    },
  );
}
