import 'package:flutter/material.dart';

class AddPageController {
  const AddPageController();

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
