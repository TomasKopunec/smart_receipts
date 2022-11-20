import 'package:flutter/material.dart';
import '../helpers/size_helper.dart';
import '../models/receipt.dart';

class ReceiptStatusLabel extends StatelessWidget {
  final ReceiptStatus status;

  const ReceiptStatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: _getColor(status), borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: SizeHelper.getFontSize(context, size: FontSize.small)),
      ),
    );
  }

  Color _getColor(ReceiptStatus status) {
    switch (status) {
      case ReceiptStatus.active:
        return Color.fromARGB(153, 133, 255, 88);
      case ReceiptStatus.expired:
        return Color.fromARGB(202, 255, 81, 62);
      case ReceiptStatus.returned:
        return Color.fromARGB(126, 108, 108, 108);
    }
  }
}
