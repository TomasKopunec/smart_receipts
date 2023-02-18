import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/screens/tabs/returns/control_header.dart';
import 'package:smart_receipts/screens/tabs/returns/returns_entry.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';

import '../../tab_control/abstract_tab_screen.dart';

class ReturnsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Returns';
  }

  @override
  IconData getIcon() {
    return Icons.compare_arrows_sharp;
  }

  @override
  State<StatefulWidget> createState() => _ReturnsScreenState();

  @override
  String getIconTitle() {
    return 'Returns';
  }
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  late final ReceiptsProvider receipts;

  @override
  void initState() {
    receipts = Provider.of<ReceiptsProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
        headerBody: const ControlHeader(), screenBody: getScreenBody());
  }

  Widget getScreenBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Consumer<ReturnsProvider>(
          builder: (ctx, returns, _) => getBody(returns),
        ),
      ),
    );
  }

  Widget getBody(ReturnsProvider provider) {
    if (provider.source.isEmpty) {
      final title = (provider.filterValue.isNotEmpty &&
              provider.returnsSize == 0)
          ? 'Sorry, we couldn\'t find any returns that match your search criteria.'
          : 'No returns have been received yet.';

      final subtitle = (provider.filterValue.isNotEmpty &&
              provider.returnsSize == 0)
          ? 'Please check the spelling or search for another return.'
          : 'Go to the chosen receipt, generate a QR code of items you would like to return, and present it at your nearest store.';

      return NoDataFoundWidget(
        height: SizeHelper.getScreenHeight(context) * 0.5,
        title: title,
        subtitle: subtitle,
        icon: widget.getIcon(),
      );
    }

    return Column(children: provider.source.map((e) => getReturn(e)).toList());
  }

  Widget getReturn(Return r) {
    return ReturnsEntry(
      receipt: receipts.getReceiptById(r.receiptId),
      returnEntry: r,
    );
  }
}
