import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('saves the selected language and restores it on relaunch', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Traditional Chinese'));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsWidgets);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('app_locale'), 'zh_TW');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byTooltip('設定'), findsOneWidget);
    expect(find.text('日記列表'), findsWidgets);
  });
}
