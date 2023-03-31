import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';

class DateTimeDropdownButton extends StatefulWidget {
  final double width;
  final Color backgroundColor;
  final Color textColor;

  const DateTimeDropdownButton({
    super.key,
    required this.width,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  State<DateTimeDropdownButton> createState() => _DateTimeDropdownButtonState();
}

class _DateTimeDropdownButtonState extends State<DateTimeDropdownButton> {
  late DateTimeFormat _selected;

  double get iconSize {
    return SizeHelper.getScreenWidth(context) * 0.09;
  }

  @override
  void initState() {
    _selected =
        Provider.of<SettingsProvider>(context, listen: false).dateTimeFormat;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.backgroundColor),
          child: PopupMenuButton(
            color: widget.backgroundColor,
            constraints:
                BoxConstraints(maxWidth: widget.width, minWidth: widget.width),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            initialValue: _selected,
            itemBuilder: (_) {
              List<PopupMenuEntry<DateTimeFormat>> widgets = [];

              for (final item in DateTimeFormat.values) {
                widgets.add(getListItem(item));
                widgets.add(const PopupMenuDivider(
                  height: 0,
                ));
              }

              return widgets;
            },
            onSelected: (DateTimeFormat value) {
              setState(() {
                _selected = value;
              });

              Provider.of<SettingsProvider>(context, listen: false)
                  .selectDateTimeFormat(_selected);

              // print('Changing datetime format to: ${value.format}');
            },
            child: SizedBox(
              width: widget.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Icon(
                        Icons.access_time,
                        size: iconSize,
                        color: widget.textColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _selected.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          _selected.example,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_drop_down, color: widget.textColor)
                  ],
                )),
              ),
            ),
          )),
    );
  }

  PopupMenuItem<DateTimeFormat> getListItem(DateTimeFormat format) {
    return PopupMenuItem<DateTimeFormat>(
      height: 0,
      value: format,
      child: getFormatView(format),
    );
  }

  Widget getFormatView(DateTimeFormat format) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
          child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: iconSize,
            color: widget.textColor,
          ),
          SizedBox(
            width: SizeHelper.getScreenWidth(context) * 0.18,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  format.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  format.example,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
