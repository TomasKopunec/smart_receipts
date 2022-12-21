import 'package:flutter/material.dart';
import '../tab_control/abstract_tab_screen.dart';

class AddReceiptScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Add Receipt';
  }

  @override
  IconData getIcon() {
    return Icons.add;
  }

  @override
  State<StatefulWidget> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.getTitle()),
    );
  }
}
