import 'package:flutter/material.dart';
import 'package:smart_receipts/widgets/table/receipt_table.dart';

import 'abstract_tab_screen.dart';

class AllReceiptsScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return ReceiptTable(headerColor: getColor());
  }

  @override
  String getTitle() {
    return 'All';
  }

  @override
  Color getColor() {
    return Color.fromRGBO(91, 69, 151, 1);
  }

  @override
  IconData getIcon() {
    return Icons.manage_search;
  }
}
