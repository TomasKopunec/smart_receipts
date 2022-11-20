import 'package:flutter/material.dart';
import 'package:smart_receipts/models/receipt.dart';

enum SortStatus { asc, desc }

class AnimatedDropdownButton extends StatefulWidget {
  final SortStatus sortStatus;
  final Function(String) sortBy;
  final double width;
  final Color color;
  final List<ReceiptAttribute> items;
  final ReceiptAttribute selected;

  const AnimatedDropdownButton(
      {required this.sortStatus,
      required this.sortBy,
      required this.items,
      required this.selected,
      required this.color,
      required this.width});

  @override
  State<AnimatedDropdownButton> createState() => _AnimatedDropdownButtonState();
}

class _AnimatedDropdownButtonState extends State<AnimatedDropdownButton> {
  late ReceiptAttribute _oldSelected;
  late ReceiptAttribute _selected;

  @override
  void initState() {
    _selected = widget.selected;
    _oldSelected = _selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromRGBO(230, 230, 230, 1)),
        child: PopupMenuButton(
          constraints:
              BoxConstraints(maxWidth: widget.width, minWidth: widget.width),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          initialValue: _selected,
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
              _selected = value;
            });

            widget.sortBy(_selected.name);
          },
          child: SizedBox(
            width: widget.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: getSortStatusIcon(widget.sortStatus)),
                  Text(
                    _selected.toString(),
                    style: TextStyle(color: widget.color),
                  ),
                  Icon(Icons.arrow_drop_down, color: widget.color)
                ],
              )),
            ),
          ),
        ));
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
