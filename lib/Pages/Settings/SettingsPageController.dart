import 'package:flutter/material.dart';

class SettingsPageController {
  const SettingsPageController();

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
