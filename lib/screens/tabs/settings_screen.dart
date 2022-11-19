import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

class SettingsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Settings';
  }

  @override
  IconData getIcon() {
    return Icons.settings;
  }

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.getTitle()),
    );
  }
}
