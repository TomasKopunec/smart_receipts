import 'package:flutter/material.dart';
import '../helpers/size_helper.dart';
import '../models/receipt/receipt.dart';

class ReceiptStatusLabel extends StatelessWidget {
  final ReceiptStatus status;

  const ReceiptStatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: status.color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: SizeHelper.getFontSize(context, size: FontSize.small)),
      ),
    );
  }
}
