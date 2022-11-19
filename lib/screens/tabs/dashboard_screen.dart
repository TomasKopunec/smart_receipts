import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

class DashboardScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Dashboard';
  }

  @override
  IconData getIcon() {
    return Icons.home;
  }

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.getTitle()),
    );
  }
}
