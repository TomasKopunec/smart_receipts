import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';

import 'abstract_tab_screen.dart';

class DashboardScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: NoDataFoundWidget(
      color: appColor,
      title: 'Sorry, we couldn\'t find this item in any of your receipts.',
      subtitle:
          'Please check the spelling or search for another item. askljdfkasjlkdsajlkadsjads',
      height: SizeHelper.getScreenHeight(context) * 0.5,
    ));
  }

  @override
  String getTitle() {
    return 'Dashboard';
  }

  @override
  IconData getIcon() {
    return Icons.dashboard;
  }
}
