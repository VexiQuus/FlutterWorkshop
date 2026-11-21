import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Pages/Settings/SettingsPage.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows the app version and build number', (tester) async {
    final documentsDirectory = Directory.systemTemp.createTempSync(
      'settings_app_version_test',
    );
    addTearDown(() => documentsDirectory.deleteSync(recursive: true));

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
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Flutter Workshop',
      packageName: 'com.example.flutterworkshop',
      version: '1.0.1',
      buildNumber: '2',
      buildSignature: '',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
        home: SettingsPage(
          onLocaleChanged: (_) async => true,
          onClearAll: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('App version'), findsOneWidget);
    expect(find.text('Version 1.0.1 (build 2)'), findsOneWidget);
  });
}
