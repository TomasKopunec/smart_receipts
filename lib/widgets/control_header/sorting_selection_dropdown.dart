import 'package:flutter/material.dart';

enum SortStatus { asc, desc }

class SortingSelectionDropdown extends StatefulWidget {
  final List<dynamic> items;
  final Function(dynamic value) onSelected;
  final Function() getSortStatus;
  final Function() getValue;

  const SortingSelectionDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    required this.getSortStatus,
    required this.getValue,
  });

  @override
  State<SortingSelectionDropdown> createState() =>
      _SortingSelectionDropdownState();
}

class _SortingSelectionDropdownState extends State<SortingSelectionDropdown> {
  @override
  Widget build(BuildContext context) {
    // final width = SizeHelper.getScreenWidth(context) * 0.45;

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).focusColor),
        child: PopupMenuButton(
          // constraints: BoxConstraints(maxWidth: width, minWidth: width),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          initialValue: widget.getValue(),
          itemBuilder: (_) {
            List<PopupMenuEntry<dynamic>> widgets = [];

            for (final item in widget.items) {
              widgets.add(PopupMenuItem(
                key: ValueKey(item.hashCode),
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
          onSelected: (value) => setState(() {
            widget.onSelected(value);
          }),
          child: SizedBox(
            // width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: getSortStatusIcon(widget.getSortStatus())),
                  Text(
                    widget.getValue().toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  Icon(Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor)
                ],
              )),
            ),
          ),
        ));
  }

  Icon getSortStatusIcon(SortStatus sortStatus) {
    switch (sortStatus) {
      case SortStatus.asc:
        return Icon(Icons.arrow_upward, color: Theme.of(context).primaryColor);
      case SortStatus.desc:
        return Icon(Icons.arrow_downward,
            color: Theme.of(context).primaryColor);
    }
  }
}
