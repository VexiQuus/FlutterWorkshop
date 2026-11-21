import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/Pages/HomePage/HomePage.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows selected journal details in two panes when fully open', (
    tester,
  ) async {
    const foldChannel = EventChannel('itchi_flutter_duo_layout/fold');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(
          foldChannel,
          MockStreamHandler.inline(
            onListen: (_, events) {
              events.success({
                'version': 1,
                'availability': 'available',
                'pose': 'fullyOpen',
                'hingeStatus': 'fullyOpen',
                'angleDegrees': 180.0,
                'windowWidth': 800.0,
                'windowHeight': 600.0,
                'spansBothPanes': true,
              });
            },
          ),
        );
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(foldChannel, null),
    );
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
        home: HomePage(onLocaleChanged: (_) async => true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A New Beginning'), findsNWidgets(2));
    expect(find.text('Started writing in my journal today.'), findsNWidgets(2));
  });
}
