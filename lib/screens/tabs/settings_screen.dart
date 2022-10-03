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
  IconData getIcon() {
    return Icons.settings;
  }
}
