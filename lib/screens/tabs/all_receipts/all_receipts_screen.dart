import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/color_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/control_header.dart';
import 'package:smart_receipts/widgets/responsive_table/receipt_table.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import '../abstract_tab_screen.dart';

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
    return Container(
      color: Colors.black.withOpacity(0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ControlHeader(color: widget.getColor(context)),
          SizedBox(
            height: 3,
          ),
          Expanded(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: ReceiptTable(),
          )),
        ],
      ),
    );
  }
}
