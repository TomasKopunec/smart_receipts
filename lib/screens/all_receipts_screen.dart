import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/bottom_navigation_bar_item.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';
import 'package:smart_receipts/widgets/receipt_table.dart';

class AllReceiptsScreen extends AbstractScreen {
  @override
  Widget build(BuildContext context) {
    // Build the header with possible filters / sorting functionality

    // Build the individual rows

    // Our table will be stateful widget

    return ReceiptTable(headerColor: getColor());

    /*
    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.all(10),
        child: DataTable(
          sortColumnIndex: 0,
          columnSpacing: 30,
          columns: [
            DataColumn(
              label: Text("ID"),
              numeric: true,
              onSort: (colIndex, ascending) {
                // Call sort by ID on our list (Stae)
              },
            ),
            DataColumn(
              label: Text("Shop"),
              numeric: false,
              onSort: (colIndex, ascending) {
                // Call sort by shop name
              },
            ),
            DataColumn(label: Text("Date")),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text("2")),
              DataCell(Text("H&M")),
              DataCell(Text(DateFormat.yMMMMd().format(DateTime.now()))),
            ]),
            DataRow(cells: [
              DataCell(Text("1")),
              DataCell(Text("Zara")),
              DataCell(Text(DateFormat.yMMMMd().format(DateTime.now()))),
            ]),
            DataRow(cells: [
              DataCell(Text("3")),
              DataCell(Text('Sainsbury\'s')),
              DataCell(Text(DateFormat.yMMMMd().format(DateTime.now()))),
            ]),
          ],
        ),
      ),
    );

    */
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
