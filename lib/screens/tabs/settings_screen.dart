import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

class SettingsScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(getTitle())),
    );
  }

  @override
  String getTitle() {
    return 'Settings';
  }

  @override
  Color getColor() {
    return const Color.fromARGB(255, 59, 59, 59);
  }

  @override
  IconData getIcon() {
    return Icons.settings;
  }
}
