import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';

class AddReceiptScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(PlaygroundScreen.route);
          },
          child: Text('Press me')),
    );
  }

  @override
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(),
        icon: const Icon(Icons.add),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'Add Receipt';
  }

  @override
  Color getColor() {
    return const Color.fromRGBO(103, 125, 220, 1);
  }
}
