import 'package:smart_receipts/screens/returnable_screen.dart';
import 'package:flutter/material.dart';

class PlaygroundScreen extends StatelessWidget {
  static const route = '/playground';

  @override
  Widget build(BuildContext context) {
    return const ReturnableScreen(
        receiptId: "1",
        title: 'Returnable Screen',
        body: Center(
          child: Text('Hello world'),
        ));
  }
}
