import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

void main() {
  for (final locale in const [Locale('en'), Locale('zh', 'TW')]) {
    testWidgets('loads app strings for $locale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
          home: Builder(
            builder: (context) {
              final strings = AppLocalizations.of(context)!;
              return Scaffold(
                body: Column(
                  children: [
                    Text(strings.listPageTitle),
                    Text(strings.sampleBeginningTitle),
                    Text(strings.createdOnDate('Nov 17, 2026')),
                    Text(strings.localStorageUsage(0)),
                    Text(strings.formatClearJournalData),
                  ],
                ),
              );
            },
          ),
        ),
      );

      if (locale.languageCode == 'zh') {
        expect(find.text('日記列表'), findsOneWidget);
        expect(find.text('新的開始'), findsOneWidget);
        expect(find.text('Nov 17, 2026 建立'), findsOneWidget);
        expect(find.text('已使用 0 KB'), findsOneWidget);
        expect(find.text('格式化／清除'), findsOneWidget);
      } else {
        expect(find.text('List'), findsOneWidget);
        expect(find.text('A New Beginning'), findsOneWidget);
        expect(find.text('Created on Nov 17, 2026'), findsOneWidget);
        expect(find.text('0 KB used'), findsOneWidget);
        expect(find.text('Format / Clear'), findsOneWidget);
      }
    });
  }
}
