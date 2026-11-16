import 'package:flutter/material.dart';

import 'AddPageController.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    const controller = AddPageController();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => controller.goBack(context)),
        title: const Text('Add'),
      ),
      body: Center(
        child: Text(
          'Add',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
