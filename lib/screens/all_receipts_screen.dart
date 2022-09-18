import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';
import 'package:smart_receipts/widgets/table/receipt_table.dart';

class AllReceiptsScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    return ReceiptTable(headerColor: getColor());
  }

  @override
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(),
        icon: const Icon(Icons.list),
        label: getTitle());
  }

  @override
  String getTitle() {
    return 'All';
  }

  @override
  Color getColor() {
    return const Color.fromARGB(255, 91, 69, 151);
  }
}
