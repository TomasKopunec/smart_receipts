import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import 'abstract_tab_screen.dart';

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
