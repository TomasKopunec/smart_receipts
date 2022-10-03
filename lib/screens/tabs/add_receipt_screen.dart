import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';

import 'abstract_tab_screen.dart';

class AddReceiptScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(PlaygroundScreen.route);
          },
          child: const Text('Press me')),
    );
  }

  @override
  String getTitle() {
    return 'Add Receipt';
  }

  @override
  IconData getIcon() {
    return Icons.add;
  }
}
