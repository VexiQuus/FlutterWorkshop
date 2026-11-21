import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.onLocaleChanged,
    required this.onClearAll,
  });

  final Future<bool> Function(Locale locale) onLocaleChanged;
  final Future<void> Function() onClearAll;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _controller = SettingsPageController();

  bool _isSaving = false;
  String? _saveError;
  bool _isClearing = false;
  String? _clearError;
  bool _clearSucceeded = false;
  bool _isStorageSizeLoading = true;
  int? _storageSizeBytes;
  String? _storageSizeError;
  late final Future<PackageInfo> _appInfo;

  @override
  void initState() {
    super.initState();
    _appInfo = PackageInfo.fromPlatform();
    unawaited(_loadStorageSize());
  }

  Future<void> _loadStorageSize() async {
    try {
      final size = await _controller.localStorageSizeBytes();
      if (mounted) {
        setState(() {
          _storageSizeBytes = size;
          _storageSizeError = null;
          _isStorageSizeLoading = false;
        });
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() {
          _storageSizeError = error.toString();
          _isStorageSizeLoading = false;
        });
      }
    }
  }

  Future<void> _retryStorageSize() async {
    setState(() {
      _isStorageSizeLoading = true;
      _storageSizeError = null;
    });
    await _loadStorageSize();
  }

  Future<void> _confirmAndClear() async {
    if (_isClearing) {
      return;
    }

    final strings = AppLocalizations.of(context)!;
    final firstConfirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.clearAllFirstTitle),
        content: Text(strings.clearAllFirstMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.continueAction),
          ),
        ],
      ),
    );
    if (firstConfirmation != true || !mounted) {
      return;
    }

    final secondConfirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.clearAllSecondTitle),
        content: Text(strings.clearAllSecondMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.clearAllConfirm),
          ),
        ],
      ),
    );
    if (secondConfirmation != true || !mounted) {
      return;
    }

    setState(() {
      _isClearing = true;
      _clearError = null;
      _clearSucceeded = false;
    });

    try {
      await widget.onClearAll();
      if (mounted) {
        setState(() => _clearSucceeded = true);
      }
    } on Exception catch (error) {
      if (mounted) {
        setState(() => _clearError = strings.clearAllError(error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isClearing = false);
        await _retryStorageSize();
      }
    }
  }

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
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => _controller.goBack(context)),
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
              const SizedBox(height: 32),
              Text(
                strings.localStorageSizeTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (_isStorageSizeLoading)
                Text(
                  strings.localStorageUsage(0),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              else if (_storageSizeError != null)
                Column(
                  children: [
                    Text(
                      strings.localStorageSizeLoadError(_storageSizeError!),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => unawaited(_retryStorageSize()),
                      child: Text(strings.retry),
                    ),
                  ],
                )
              else
                Text(
                  strings.localStorageUsage(
                    (_storageSizeBytes! / 1024).round(),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 32),
              Text(
                strings.appVersionTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              FutureBuilder<PackageInfo>(
                future: _appInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LinearProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text(
                      strings.appVersionLoadError(
                        snapshot.error.toString(),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }

                  final packageInfo = snapshot.requireData;
                  return Text(
                    strings.appVersionAndBuild(
                      packageInfo.version,
                      packageInfo.buildNumber,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                },
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: _isClearing ? null : _confirmAndClear,
                icon: const Icon(Icons.delete_forever),
                label: Text(strings.formatClearJournalData),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              if (_isClearing) ...[
                const SizedBox(height: 12),
                const LinearProgressIndicator(),
              ],
              if (_clearError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _clearError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              if (_clearSucceeded) ...[
                const SizedBox(height: 12),
                Text(strings.clearAllSuccess, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
