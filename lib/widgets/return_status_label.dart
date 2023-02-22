import 'package:flutter/material.dart';
import '../helpers/size_helper.dart';

enum ReturnStatus {
  issued(Colors.teal, "Refund Issued");
  //processing(Color.fromRGBO(135, 100, 151, 1), "Processing"),
  // denied(Color.fromRGBO(216, 90, 78, 1), "Denied");

  final Color color;
  final String title;

  const ReturnStatus(
    this.color,
    this.title,
  );
}

class ReturnStatusLabel extends StatelessWidget {
  final int index;

  const ReturnStatusLabel({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final status = ReturnStatus.values.elementAt(index);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color: status.color, borderRadius: BorderRadius.circular(6)),
      child: Text(
        status.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: SizeHelper.getFontSize(context, size: FontSize.small),
        ),
      ),
    );
  }
}
