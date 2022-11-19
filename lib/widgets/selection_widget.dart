import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/size_helper.dart';
import '../providers/receipts_provider.dart';

class SelectionWidget extends StatefulWidget {
  final Color color;

  const SelectionWidget({required this.color});

  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      side: BorderSide(width: 1.0, color: Colors.white.withOpacity(0.5)),
    );

    return Consumer<ReceiptsProvider>(
      builder: (context, provider, child) {
        const double disabledOpacity = 0.6;
        final total = provider.selectedsLen;
        final red =
            total == 0 ? Colors.red.withOpacity(disabledOpacity) : Colors.red;
        final yellow = total == 0
            ? Colors.yellow.withOpacity(disabledOpacity)
            : Colors.yellow;

        return Container(
          decoration: BoxDecoration(
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        Provider.of<ReceiptsProvider>(context, listen: false)
                            .flipFavorites(provider.selecteds);
                      },
                      icon: Icon(
                        Icons.star,
                        color: yellow,
                      ),
                      label: Text(
                        total > 0 ? 'Star ($total)' : 'Star',
                        style: TextStyle(color: yellow),
                      )),
                  OutlinedButton(
                      style: style,
                      onPressed: () {
                        if (total == 0) {
                          provider.receipts
                              .map((e) => e.uid.value)
                              .toList()
                              .forEach((uid) {
                            provider.addSelectedByUID(uid);
                          });
                        } else {
                          provider.clearSelecteds(notify: true);
                        }
                      },
                      child: Text(
                        total == 0 ? 'Select All' : 'Unselect All',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: SizeHelper.getFontSize(context,
                                size: FontSize.regular)),
                      )),
                  TextButton.icon(
                      onPressed: () {
                        print(
                            'Deleting receipts with following ids: ${provider.selecteds}');
                      },
                      icon: Icon(
                        Icons.delete,
                        color: red,
                      ),
                      label: Text(
                        total > 0 ? 'Delete ($total)' : 'Delete',
                        style: TextStyle(color: red),
                      )),
                ],
              )),
        );
      },
    );
  }
}
