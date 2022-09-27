import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

class PlaygroundScreen extends StatelessWidget {
  static const route = '/playground';

  @override
  Widget build(BuildContext context) {
    return ReturnableScreen(
        title: 'Returnable Screen',
        appbarColor: const Color.fromRGBO(103, 125, 220, 1),
        body: Center(
          child: Text('Hello world'),
        ));
  }
}
