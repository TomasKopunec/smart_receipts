import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/color_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/responsive_table/receipt_table.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import 'abstract_tab_screen.dart';

class AllReceiptsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'All';
  }

  @override
  IconData getIcon() {
    return Icons.manage_search;
  }

  @override
  State<StatefulWidget> createState() => _AllReceiptsState();
}

class _AllReceiptsState extends State<AllReceiptsScreen> {
  @override
  void initState() {
    // On load clear the selection
    Provider.of<ReceiptsProvider>(context, listen: false)
        .clearSelecteds(notify: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (context, provider, child) {
        final bool isSelecting = provider.isSelecting;

        return Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          child!,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 900),
            height: isSelecting ? SizeHelper.getSelectionHeight(context) : 0,
            width: SizeHelper.getScreenWidth(context),
            // width: double.infinity,
            curve: Curves.fastLinearToSlowEaseIn,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: isSelecting ? 1 : 0,
              child: const SelectionWidget(
                color: ColorHelper.APP_COLOR,
              ),
            ),
          ),
        ]);
      },
      child: ReceiptTable(headerColor: widget.appColor),
    );
  }
}
