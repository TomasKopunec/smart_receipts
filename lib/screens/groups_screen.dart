import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_tab_screen.dart';

class GroupsScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(getTitle())),
    );
  }

  @override
  String getTitle() {
    return 'Groups';
  }

  @override
  Color getColor() {
    return const Color.fromRGBO(89, 201, 165, 1);
  }

  @override
  IconData getIcon() {
    return Icons.shopping_bag_rounded;
  }
}
