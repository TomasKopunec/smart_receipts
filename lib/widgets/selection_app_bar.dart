import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import '../providers/nav_bar_provider.dart';

class SelectionAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool selecting;
  final Color color;

  SelectionAppBar({required this.color, required this.selecting})
      : preferredSize = const Size.fromHeight(kToolbarHeight * 0.9);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _SelectionAppBarState createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends State<SelectionAppBar> {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<NavBarProvider>(context, listen: false);

    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) {
        const double disabledOpacity = 0.6;
        final total = provider.selectedsLen;
        final red =
            total == 0 ? Colors.red.withOpacity(disabledOpacity) : Colors.red;
        final yellow = total == 0
            ? Colors.yellow.withOpacity(disabledOpacity)
            : Colors.yellow;

        return AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            )),
            backgroundColor: widget.color,
            primary: true,
            elevation: 6,
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          print(
                              'Staring receipts with following ids: ${provider.selecteds}');
                        },
                        icon: Icon(
                          Icons.star,
                          color: yellow,
                        ),
                        label: Text(
                          total > 0 ? 'Star ($total)' : 'Star',
                          style: TextStyle(color: yellow),
                        )),
                    Text(
                      'Select Receipts',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.regular)),
                    ),
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
                )));
      },
    );
  }
}
