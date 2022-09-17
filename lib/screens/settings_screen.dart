import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';

class SettingsScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(getTitle())),
    );
  }

  @override
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(),
        icon: const Icon(Icons.settings),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'Settings';
  }

  @override
  Color getColor() {
    return const Color.fromARGB(255, 59, 59, 59);
  }
}
