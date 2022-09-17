import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';

class DashboardScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Dashboard")),
    );
  }

  @override
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(),
        icon: const Icon(Icons.dashboard),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'Dashboard';
  }

  @override
  Color getColor() {
    return const Color.fromRGBO(216, 30, 91, 1);
  }
}
