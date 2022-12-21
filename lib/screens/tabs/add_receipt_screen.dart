import 'package:flutter/material.dart';
import '../tab_control/abstract_tab_screen.dart';

class AddReceiptScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Add Receipt';
  }

  @override
  IconData getIcon() {
    return Icons.qr_code_scanner_rounded;
  }

  @override
  State<StatefulWidget> createState() => _AddReceiptScreenState();

  @override
  String getIconTitle() {
    return 'Add';
  }
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.getScreen();
  }
}
