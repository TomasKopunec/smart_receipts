import 'package:flutter/material.dart';

import '../tab_control/abstract_tab_screen.dart';

class ReturnsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Returns';
  }

  @override
  IconData getIcon() {
    return Icons.keyboard_return_rounded;
  }

  @override
  State<StatefulWidget> createState() => _ReturnsScreenState();

  @override
  String getIconTitle() {
    return 'Returns';
  }
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.getScreen();
  }
}
