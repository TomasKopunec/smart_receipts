import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_tab_screen.dart';
import 'package:smart_receipts/widgets/table/receipt_table.dart';

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
    return const Color.fromARGB(255, 91, 69, 151);
  }

  @override
  IconData getIcon() {
    return Icons.manage_search;
  }
}
