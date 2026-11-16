import 'package:flutter/material.dart';

import 'DetailPageController.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const controller = DetailPageController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: const Text('Detail'),
      ),
      body: Center(
        child: Text(
          'Detail',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
