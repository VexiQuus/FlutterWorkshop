import 'package:flutter/material.dart';

class DetailPageController {
  const DetailPageController();

  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }
}
