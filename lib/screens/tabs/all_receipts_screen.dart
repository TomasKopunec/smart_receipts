import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/responsive_table/receipt_table.dart';

import 'abstract_tab_screen.dart';

class AllReceiptsScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    // On load clear the selecton
    Provider.of<ReceiptsProvider>(context, listen: false)
        .clearSelecteds(notify: false);

    return ReceiptTable(headerColor: appColor);
  }

  @override
  String getTitle() {
    return 'All';
  }

  @override
  IconData getIcon() {
    return Icons.manage_search;
  }
}
