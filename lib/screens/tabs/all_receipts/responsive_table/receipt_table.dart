import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/responsive_table/datatable.dart';

import '../../../../models/receipt/receipt.dart';

class ReceiptTable extends StatefulWidget {
  final VoidCallback refreshData;
  final bool isLoading;

  const ReceiptTable({
    super.key,
    required this.refreshData,
    this.isLoading = false,
  });

  @override
  State<ReceiptTable> createState() => _ReceiptTableState();
}

class _ReceiptTableState extends State<ReceiptTable> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReceiptsProvider>(context, listen: false);

    final title = (provider.filterValue.isNotEmpty && provider.receiptSize == 0)
        ? 'Sorry, we couldn\'t find any receipts that match your search criteria.'
        : 'No receipts have been received yet.';

    final subtitle = (provider.filterValue.isNotEmpty &&
            provider.receiptSize == 0)
        ? 'Please check the spelling or search for another receipt.'
        : 'Make a purchase and scan your personal QR code to receive a digital receipt during the next checkout.';

    return ResponsiveDatatable(
      groupType: getGroupType(provider.searchKey),
      isSelecting: provider.isSelecting,
      noDataWidget: NoDataFoundWidget(
          icon: Icons.receipt,
          height: SizeHelper.getScreenHeight(context) * 0.5,
          title: title,
          subtitle: subtitle),
      prefferedColor: Theme.of(context).primaryColor,
      total: provider.receiptSize,
      headers: Receipt.getSearchableKeys(),
      source: provider.source,
      isLoading: widget.isLoading,
    );
  }

  GroupType getGroupType(ReceiptField searchKey) {
    if (searchKey == ReceiptField.purchaseDateTime) {
      return GroupType.purchaseTime;
    } else if (searchKey == ReceiptField.retailerName) {
      return GroupType.retailerName;
    } else if (searchKey == ReceiptField.status) {
      return GroupType.status;
    } else if (searchKey == ReceiptField.purchaseLocation) {
      return GroupType.location;
    } else {
      return GroupType.none;
    }
  }

  LinearProgressIndicator get loadingIndicator {
    return LinearProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      color: Theme.of(context).primaryColor,
    );
  }
}
