import 'package:flutter/material.dart';
import 'package:smart_receipts/models/receipt.dart';

enum SortStatus { asc, desc }

class AnimatedDropdownButton extends StatefulWidget {
  final Function(String, SortStatus) sortBy;
  final double width;
  final Color color;
  final List<ReceiptAttribute> items;
  final ReceiptAttribute selected;

  const AnimatedDropdownButton(
      {required this.sortBy,
      required this.items,
      required this.selected,
      required this.color,
      required this.width});

  @override
  State<AnimatedDropdownButton> createState() => _AnimatedDropdownButtonState();
}

class _AnimatedDropdownButtonState extends State<AnimatedDropdownButton> {
  SortStatus _sortStatus = SortStatus.asc;

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

              if (_selected != _oldSelected) {
                _sortStatus = SortStatus.asc;
                _oldSelected = _selected;
                return;
              }

              if (_sortStatus == SortStatus.asc) {
                _sortStatus = SortStatus.desc;
              } else if (_sortStatus == SortStatus.desc) {
                _sortStatus = SortStatus.asc;
              } else {
                _sortStatus = SortStatus.asc;
              }
            });

            widget.sortBy(_selected.name, _sortStatus);
          },
          child: SizedBox(
            width: widget.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sortStatus,
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

  Icon get sortStatus {
    switch (_sortStatus) {
      case SortStatus.asc:
        return Icon(Icons.arrow_upward, color: widget.color);
      case SortStatus.desc:
        return Icon(Icons.arrow_downward, color: widget.color);
    }
  }
}
