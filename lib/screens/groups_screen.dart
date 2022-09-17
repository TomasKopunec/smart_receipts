import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';

class GroupsScreen extends AbstractScreen {
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
        icon: const Icon(Icons.group),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'Groups';
  }

  @override
  Color getColor() {
    return const Color.fromRGBO(89, 201, 165, 1);
  }
}
