import 'package:smart_receipts/screens/returnable_screen.dart';
import 'package:flutter/material.dart';

class PlaygroundScreen extends StatelessWidget {
  static const route = '/playground';

  @override
  Widget build(BuildContext context) {
    return const ReturnableScreen(
        title: 'Returnable Screen',
        appbarColor: Color.fromRGBO(103, 125, 220, 1),
        body: Center(
          child: Text('Hello world'),
        ));
  }
}
