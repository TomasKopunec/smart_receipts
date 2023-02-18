import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
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
  late final ReceiptsProvider _receiptsProvider;
  bool _isLoading = false;
  final ScrollController _controller = ScrollController();

  /* Asynchronous operations */
  void _refreshData() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    await _receiptsProvider.fetchAndSetReceipts(
        Provider.of<AuthProvider>(context, listen: false).token!.accessToken);

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => _isLoading = false);
  }

  @override
  void setState(func) {
    if (mounted) {
      super.setState(() {
        func();
      });
    }
  }

  @override
  void initState() {
    // Initialise Receipts Provider
    _receiptsProvider = Provider.of<ReceiptsProvider>(context, listen: false);

    // Reload state when receipts change
    _receiptsProvider.addListener(() => setState(() => {}));

    // On load clear the selection
    _receiptsProvider.clearSelecteds(notify: false);

    _controller.addListener(() {
      double pixels = _controller.position.pixels;
      if (_isLoading) {
        return;
      }

      // If we pull the scroll to refresh
      if (pixels <= SizeHelper.getScreenHeight(context) * 0.1) {
        _refreshData();
      } else {
        _isLoading = false;
      }
    });

    // Allow landscape in this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    // Reset the screen everytime opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _receiptsProvider.resetSource();
    });

    super.initState();
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
        headerBody: ControlHeader(isLoading: _isLoading),
        screenBody: SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ReceiptTable(refreshData: _refreshData, isLoading: _isLoading),
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
