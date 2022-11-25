import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

enum SortStatus { asc, desc }

class AnimatedDropdownButton extends StatefulWidget {
  final double width;
  final Color color;
  final List<ReceiptAttribute> items = ReceiptAttribute.values;

  const AnimatedDropdownButton({required this.color, required this.width});

  @override
  State<AnimatedDropdownButton> createState() => _AnimatedDropdownButtonState();
}

class _AnimatedDropdownButtonState extends State<AnimatedDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color.fromRGBO(230, 230, 230, 1)),
            child: PopupMenuButton(
              constraints: BoxConstraints(
                  maxWidth: widget.width, minWidth: widget.width),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              initialValue: provider.searchKey,
              itemBuilder: (_) {
                List<PopupMenuEntry<ReceiptAttribute>> widgets = [];

                for (final item in widget.items) {
                  widgets.add(PopupMenuItem(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    height: 0,
                    value: item,
                    child: Center(
                      child: Text(
                        item.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ));
                  widgets.add(const PopupMenuDivider(
                    height: 0,
                  ));
                }

                return widgets;
              },
              onSelected: (ReceiptAttribute value) {
                setState(() {
                  provider.setSearchKey(value);
                });
              },
              child: SizedBox(
                width: widget.width,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: getSortStatusIcon(provider.sortStatus)),
                      Text(
                        provider.searchKey.toString(),
                        style: TextStyle(color: widget.color),
                      ),
                      Icon(Icons.arrow_drop_down, color: widget.color)
                    ],
                  )),
                ),
              ),
            ));
      },
    );
  }

  Icon getSortStatusIcon(SortStatus sortStatus) {
    switch (sortStatus) {
      case SortStatus.asc:
        return Icon(Icons.arrow_upward, color: widget.color);
      case SortStatus.desc:
        return Icon(Icons.arrow_downward, color: widget.color);
    }
  }
}
