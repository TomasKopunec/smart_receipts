import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

import '../models/product/product.dart';
import '../models/receipt/receipt.dart';

class ShowReceiptScreen extends StatelessWidget {
  const ShowReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    final Receipt receipt =
        Provider.of<ReceiptsProvider>(context, listen: false)
            .getReceiptById(id);

    return ReturnableScreen(
        title: receipt.retailer_name,
        appbarColor: Colors.amber,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                children:
                    receipt.toJson().entries.map((e) => getEntry(e)).toList()),
          ),
        ));
  }

  Widget getEntry(MapEntry<String, dynamic> e) {
    if (e.key == 'products') {
      List<Widget> widgets = (e.value as List<Product>)
          .map((e) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.id.toString()),
                  Text(e.name),
                  Text(e.price.toString()),
                  Text(e.sku),
                ],
              ))
          .toList();
      return Column(
        children: [Text('Products: '), ...widgets],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text(e.key), Text(e.value.toString())],
    );
  }
}
