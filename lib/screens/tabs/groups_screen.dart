import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

class GroupsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Groups';
  }

  @override
  IconData getIcon() {
    return Icons.shopping_bag_outlined;
  }

  @override
  State<StatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.getTitle()),
    );
  }
}
