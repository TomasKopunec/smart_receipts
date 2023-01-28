import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

import '../helpers/size_helper.dart';
import '../widgets/dialogs/confirm_dialog.dart';

/// Screen that can be returned (opened from Navigator push)
class ReturnableScreen extends StatelessWidget {
  final int receiptId;
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
    final result = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
          title: 'Delete Receipt',
          subtitle: 'Are you sure you want to remove this receipt?',
          color: Theme.of(context).primaryColor,
          width: SizeHelper.getScreenWidth(context) * 0.9),
    );

    if (result != null && result) {
      // TODO Remove receipt
      print('Removing receipt with id: ${receiptId}');
    }
  }
}
