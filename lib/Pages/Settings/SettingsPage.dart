import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        child: Text(
          strings.settings,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
