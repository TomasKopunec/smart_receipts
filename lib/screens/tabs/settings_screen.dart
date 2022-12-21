import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/settings_provider.dart';

import '../tab_control/abstract_tab_screen.dart';

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
    return Consumer<SettingsProvider>(
      builder: (ctx, provider, child) {
        return widget.getScreen();
      },
    );
  }
}
