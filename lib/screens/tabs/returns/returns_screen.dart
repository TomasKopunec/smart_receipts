import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/screens/tabs/returns/control_header.dart';

import '../../tab_control/abstract_tab_screen.dart';

class ReturnsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Returns';
  }

  @override
  IconData getIcon() {
    return Icons.keyboard_return_rounded;
  }

  @override
  State<StatefulWidget> createState() => _ReturnsScreenState();

  @override
  String getIconTitle() {
    return 'Returns';
  }
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
        headerBody: const ControlHeader(),
        screenBody: Consumer<ReturnsProvider>(
          builder: (ctx, returns, _) => Column(
            children: returns.returns.map((e) => getReturn(e)).toList(),
          ),
        ));
    ;
  }

  Widget getReturn(Return r) {
    return Card(
      child: ExpansionTile(
        title: Text(r.receiptId),
        subtitle: Text(r.refundedAmount.toString()),
        leading: Text(r.returnedItems.length.toString()),
      ),
    );
  }
}
