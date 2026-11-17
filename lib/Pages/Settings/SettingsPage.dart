import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.onLocaleChanged});

  final Future<bool> Function(Locale locale) onLocaleChanged;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSaving = false;
  String? _saveError;

  Future<void> _selectLocale(Locale locale) async {
    if (_isSaving || locale == Localizations.localeOf(context)) {
      return;
    }

    final strings = AppLocalizations.of(context)!;
    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      final saved = await widget.onLocaleChanged(locale);
      if (!saved && mounted) {
        setState(() => _saveError = strings.languagePreferenceSaveRejected);
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(
          () => _saveError = strings.languagePreferenceSaveError(
            error.toString(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const controller = SettingsPageController();
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: Text(strings.settings),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                strings.settings,
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                strings.languageSettingTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<Locale>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: const Locale('en'),
                    label: Text(strings.languageOptionEnglish),
                  ),
                  ButtonSegment(
                    value: const Locale('zh', 'TW'),
                    label: Text(strings.languageOptionTraditionalChinese),
                  ),
                ],
                selected: {Localizations.localeOf(context)},
                onSelectionChanged: _isSaving
                    ? null
                    : (selection) {
                        if (selection.isNotEmpty) {
                          unawaited(_selectLocale(selection.first));
                        }
                      },
              ),
              if (_isSaving) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              if (_saveError != null) ...[
                const SizedBox(height: 16),
                Text(
                  _saveError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
