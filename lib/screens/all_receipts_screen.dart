import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/bottom_navigation_bar_item.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';

class AllReceiptsScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("All receipts")),
    );
  }

  @override
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(),
        icon: const Icon(Icons.list),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'All';
  }

  @override
  Color getColor() {
    return const Color.fromARGB(255, 91, 69, 151);
  }
}
