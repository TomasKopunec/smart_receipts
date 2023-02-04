import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';

class DatatableDesktopHeader extends StatelessWidget {
  final Color color;
  final List<ReceiptField> headers;
  final BoxDecoration decoration;
  final bool isSelecting;

  const DatatableDesktopHeader(
      {super.key,
      required this.isSelecting,
      required this.headers,
      required this.decoration,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (isSelecting)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              color: color,
              width: SizeHelper.getIconSize(context, size: IconSize.large),
              child: const Text(''),
            ),
          ...headers
              .map(
                (header) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: color.withOpacity(1),
                        border: const Border(
                            right:
                                BorderSide(color: Colors.white24, width: 1))),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    alignment: Alignment.center,
                    child: Text(
                      header.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.95)),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
