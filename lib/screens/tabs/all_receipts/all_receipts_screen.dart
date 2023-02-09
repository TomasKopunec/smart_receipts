import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/control_header.dart';
import 'package:smart_receipts/widgets/responsive_table/receipt_table.dart';

import '../../../utils/snackbar_builder.dart';
import '../../tab_control/abstract_tab_screen.dart';

class AllReceiptsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'All Receipts';
  }

  @override
  IconData getIcon() {
    return Icons.receipt;
  }

  @override
  State<StatefulWidget> createState() => _AllReceiptsState();

  @override
  String getIconTitle() {
    return 'All';
  }
}

class _AllReceiptsState extends State<AllReceiptsScreen> {
  @override
  void initState() {
    // On load clear the selection
    Provider.of<ReceiptsProvider>(context, listen: false)
        .clearSelecteds(notify: false);

    super.initState();

    // Allow landscape in this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  @override
  void dispose() {
    // Handle disposal properly
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
        action: action,
        headerBody: const ControlHeader(),
        screenBody: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ReceiptTable(),
        ));
  }

  Widget get action {
    return Consumer<ReceiptsProvider>(
      builder: (_, provider, __) {
        return TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor.withOpacity(0.2)),
            ),
            onPressed: () {
              if (provider.receiptSize == 0) {
                AppSnackBar.show(
                    context,
                    AppSnackBarBuilder()
                        .withText('No receipts available.')
                        .withDuration(const Duration(seconds: 3)));
                return;
              }

              if (provider.isSelecting) {
                provider.clearSelecteds(notify: true);
              }

              provider.toggleSelecting();
            },
            child: Text(
              provider.isSelecting ? 'Cancel' : 'Select',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.regular)),
            ));
      },
    );
  }
}
