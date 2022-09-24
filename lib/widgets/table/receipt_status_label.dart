import 'package:flutter/material.dart';
import '../../helpers/size_helper.dart';
import '../../models/receipt.dart';

class ReceiptStatusLabel extends StatelessWidget {
  final Color color;
  final ReceiptStatus status;

  const ReceiptStatusLabel({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color: _getColor(status), borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
            fontSize: SizeHelper.getFontSize(context, size: FontSize.small)),
      ),
    );
  }

  Color _getColor(ReceiptStatus status) {
    switch (status) {
      case ReceiptStatus.active:
        return const Color.fromRGBO(0, 255, 0, 0.6);
      case ReceiptStatus.expired:
        return const Color.fromRGBO(255, 0, 0, 0.5);
      case ReceiptStatus.invalid:
        return const Color.fromRGBO(255, 200, 0, 0.5);
      case ReceiptStatus.redeemed:
        return color.withOpacity(0.6);
    }
  }
}
