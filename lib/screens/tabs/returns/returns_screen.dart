import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/screens/tabs/returns/returns_entry.dart';
import 'package:smart_receipts/widgets/control_header/control_header_builder.dart';
import 'package:smart_receipts/widgets/no_data_found_widget.dart';
import 'package:smart_receipts/widgets/shimmer_widget.dart';

import '../../tab_control/abstract_tab_screen.dart';

class ReturnsScreen extends AbstractTabScreen {
  const ReturnsScreen({super.key});

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
  bool _isLoading = false;
  final ScrollController _controller = ScrollController();
  late final ReceiptsProvider _receipts;
  late final ReturnsProvider _returns;

  /* Asynchronous operations */
  void _refreshData() async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    final accessToken =
        Provider.of<AuthProvider>(context, listen: false).token!.accessToken;

    // First fetch receipts, then returns
    await _receipts.fetchAndSetReceipts(accessToken);
    await _returns.fetchAndSetReturns(accessToken);

    await Future.delayed(const Duration(milliseconds: 500));
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
    _receipts = Provider.of<ReceiptsProvider>(context, listen: false);
    _returns = Provider.of<ReturnsProvider>(context, listen: false);

    _receipts.addListener(() => setState(() => {}));
    _returns.addListener(() => setState(() => {}));

    _controller.addListener(() {
      double pixels = _controller.position.pixels;
      if (_isLoading) {
        return;
      }

      // If we pull the scroll to refresh
      final refreshThreshold = SizeHelper.getScreenHeight(context) * 0.1125;
      if (pixels <= -refreshThreshold) {
        _refreshData();
      } else {
        _isLoading = false;
      }
    });

    // Reset the screen everytime opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _returns.resetSource();
      _refreshData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
      headerBody: header,
      screenBody: SingleChildScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: getBody(_returns),
        ),
      ),
    );
  }

  Widget get header {
    return ControlHeaderBuilder()
        .withReturnsSearchBar()
        .withReturnsSorting()
        .withReturnRangeSelection(context)
        .build(context, _isLoading);
  }

  Widget getBody(ReturnsProvider provider) {
    if (_isLoading) {
      return Column(
        children: [
          const SizedBox(height: 10),
          ...List.generate(5, (index) => getBlankEntry())
        ],
      );
    }

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
    final receipt = _receipts.getReceiptById(r.receiptId);
    return ReturnsEntry(
      receipt: receipt,
      returnEntry: r,
      currency: receipt.currency,
    );
  }

  Widget getBlankEntry() {
    return ShimmerWidget(
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.zero,
          elevation: 3,
          child: const ExpansionTile(
            leading: Text(""),
            tilePadding: EdgeInsets.only(left: 10, right: 20),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(""),
            subtitle: Text(""),
            trailing: Text(""),
          ),
        ),
      ),
    );
  }
}
