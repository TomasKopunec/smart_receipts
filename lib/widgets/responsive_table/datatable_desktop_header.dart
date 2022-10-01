import 'package:flutter/material.dart';
import 'package:smart_receipts/models/receipt.dart';

class DatatableDesktopHeader extends StatelessWidget {
  final Color color;
  final List<ReceiptAttribute> headers;
  final BoxDecoration decoration;

  const DatatableDesktopHeader(
      {super.key,
      required this.headers,
      required this.decoration,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: headers
            .map(
              (header) => Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: color.withOpacity(1),
                    border: Border(
                        right: BorderSide(
                            color: Colors.white.withOpacity(0.25),
                            width: 0.4))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                alignment: Alignment.center,
                child: Text(
                  header.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.95)),
                ),
              )),
            )
            .toList(),
      ),
    );
  }
}
