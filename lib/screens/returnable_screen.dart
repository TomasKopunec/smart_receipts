import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';

/// Screen that can be returned (opened from Navigator push)
class ReturnableScreen extends StatelessWidget {
  final String receiptId;
  final String title;
  final Widget body;

  const ReturnableScreen(
      {super.key,
      required this.title,
      required this.body,
      required this.receiptId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    provider.flipFavorite(receiptId, true);
                  },
                  icon: Icon(provider.isFavorite(receiptId)
                      ? Icons.star
                      : Icons.star_border)),
              IconButton(
                  onPressed: () => _delete(context),
                  icon: const Icon(Icons.delete)),
            ],
          ),
          body: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: body,
      ),
    );
  }

  void _delete(BuildContext context) async {
    DialogHelper.showDeleteReceiptDialog(context);
  }
}
