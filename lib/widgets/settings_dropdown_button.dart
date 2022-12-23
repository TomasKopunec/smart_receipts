import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/settings_provider.dart';

class SettingsDropdownButton extends StatefulWidget {
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final dynamic initialValue;
  final List<dynamic> items;

  SettingsDropdownButton(
      {required this.width,
      required this.textColor,
      required this.backgroundColor,
      required this.items,
      required this.initialValue});

  @override
  State<SettingsDropdownButton> createState() => _SettingsDropdownButtonState();
}

class _SettingsDropdownButtonState extends State<SettingsDropdownButton> {
  late dynamic _selected;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Consumer<SettingsProvider>(
        builder: (ctx, provider, _) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: widget.backgroundColor),
              child: PopupMenuButton(
                constraints: BoxConstraints(
                    maxWidth: widget.width, minWidth: widget.width),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                initialValue: widget.initialValue,
                itemBuilder: (_) {
                  List<PopupMenuEntry<dynamic>> widgets = [];

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
                onSelected: (dynamic value) {
                  setState(() {
                    _selected = value;
                  });
                },
                child: SizedBox(
                  width: widget.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: InkWell(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _selected.toString(),
                          style: TextStyle(color: widget.textColor),
                        ),
                        Icon(Icons.arrow_drop_down, color: widget.textColor)
                      ],
                    )),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
