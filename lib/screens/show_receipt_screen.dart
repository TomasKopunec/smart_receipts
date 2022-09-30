import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

import '../models/receipt.dart';

class ShowReceiptScreen extends StatelessWidget {
  const ShowReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context)!.settings.arguments as String;
    final Receipt receipt =
        Provider.of<ReceiptsProvider>(context, listen: false)
            .getReceiptByUid(uid);

    return ReturnableScreen(
        title: receipt.storeName.value,
        appbarColor: Colors.amber,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                children: receipt
                    .asJson()
                    .entries
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(e.key),
                            Text(e.value.toString()),
                          ],
                        ))
                    .toList()),
          ),
        ));
  }
}
