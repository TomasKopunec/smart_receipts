import 'package:flutter/material.dart';
import '../helpers/size_helper.dart';
import '../models/receipt/receipt.dart';

class ReceiptStatusLabel extends StatelessWidget {
  final ReceiptStatus status;

  const ReceiptStatusLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color: status.color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize:
              SizeHelper.getFontSize(context, size: FontSize.regularSmall),
        ),
      ),
    );
  }
}
