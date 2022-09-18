import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt_column.dart';

class TableHeader extends StatefulWidget {
  final Color headerColor;
  final List<ReceiptColumn> columns;

  const TableHeader({required this.headerColor, required this.columns});

  @override
  State<TableHeader> createState() => _TableHeaderState();
}

class _TableHeaderState extends State<TableHeader> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _columns = widget.columns
        .take(widget.columns.length - 1)
        .map((e) => getColumn(e))
        .toList();
    _columns.add(getLastColumn(widget.columns.last));

    return Container(
        color: widget.headerColor.withOpacity(0.8),
        width: double.infinity,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _columns,
        ));
  }

  Widget getLastColumn(ReceiptColumn col) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: getText(col.title),
      ),
    );
  }

  Widget getColumn(ReceiptColumn col) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: widget.headerColor.withOpacity(0.9)))),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: getText(col.title),
      ),
    );
  }

  Widget getText(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          text,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: SizeHelper.getFontSize(context)),
        ),
      ),
    );
  }
}
