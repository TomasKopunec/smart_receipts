import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

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
  IconData getIcon() {
    return Icons.shopping_bag_rounded;
  }
}
