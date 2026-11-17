import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Pages/Settings/SettingsPage.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('requires two confirmations before clearing journal data', (
    tester,
  ) async {
    final documentsDirectory = Directory.systemTemp.createTempSync(
      'settings_clear_confirmation_test',
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

    var clearCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
        home: SettingsPage(
          onLocaleChanged: (_) async => true,
          onClearAll: () async {
            clearCount++;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Format / Clear'));
    await tester.pumpAndSettle();
    expect(find.text('Clear all journal data?'), findsOneWidget);
    expect(clearCount, 0);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Final confirmation'), findsOneWidget);
    expect(clearCount, 0);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(clearCount, 0);

    await tester.tap(find.text('Format / Clear'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete everything'));
    await tester.pumpAndSettle();
    expect(clearCount, 1);
  });
}
