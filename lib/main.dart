import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/HomePage/HomePage.dart';
import 'Theme/AppTheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _localeStorageKey = 'app_locale';

  Locale _locale = const Locale('en');
  bool _isLocaleLoaded = false;
  String? _localeLoadError;

  @override
  void initState() {
    super.initState();
    _locale = _deviceLocale();
    unawaited(_loadLocale());
  }

  Locale _deviceLocale() {
    for (final locale in WidgetsBinding.instance.platformDispatcher.locales) {
      if (locale.languageCode == 'zh') {
        return const Locale('zh', 'TW');
      }
      if (locale.languageCode == 'en') {
        return const Locale('en');
      }
    }
    return const Locale('en');
  }

  Future<void> _loadLocale() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final savedLocale = preferences.getString(_localeStorageKey);
      final locale = switch (savedLocale) {
        null => _deviceLocale(),
        'en' => const Locale('en'),
        'zh_TW' => const Locale('zh', 'TW'),
        _ => throw FormatException(
          'Unsupported saved language preference: $savedLocale',
        ),
      };

      if (!mounted) {
        return;
      }
      setState(() {
        _locale = locale;
        _localeLoadError = null;
        _isLocaleLoaded = true;
      });
    } on Exception catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _localeLoadError = error.toString();
        _isLocaleLoaded = true;
      });
    }
  }

  Future<bool> _saveLocale(Locale locale) async {
    final preferences = await SharedPreferences.getInstance();
    final value = locale.countryCode == 'TW' ? 'zh_TW' : 'en';
    final saved = await preferences.setString(_localeStorageKey, value);
    if (saved && mounted) {
      setState(() => _locale = locale);
    }
    return saved;
  }

  void _retryLocaleLoad() {
    setState(() {
      _isLocaleLoaded = false;
      _localeLoadError = null;
    });
    unawaited(_loadLocale());
  }

  Widget _buildLocaleLoadError(String error) {
    return Builder(
      builder: (context) {
        final strings = AppLocalizations.of(context)!;
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    strings.languagePreferenceLoadError(error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryLocaleLoad,
                    child: Text(strings.retry),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en'), Locale('zh', 'TW')],
      theme: AppTheme.light,
      home: !_isLocaleLoaded
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : _localeLoadError != null
          ? _buildLocaleLoadError(_localeLoadError!)
          : HomePage(onLocaleChanged: _saveLocale),
    );
  }
}
