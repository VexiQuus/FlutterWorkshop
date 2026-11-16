import 'package:flutter/material.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const controller = SettingsPageController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'Settings',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
