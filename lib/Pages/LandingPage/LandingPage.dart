import 'package:flutter/material.dart';
import 'package:flutterworkshop/l10n/generated/app_localizations.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(strings.landingPageTitle)),
      body: Center(child: Text(strings.landingPageWelcome)),
    );
  }
}
