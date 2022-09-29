import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

class ModalSheet extends StatelessWidget {
  final Color color;
  final VoidCallback star;
  final VoidCallback delete;

  const ModalSheet(
      {required this.color, required this.star, required this.delete});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    );

    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) {
        final total = provider.selectedsLen;
        final red = total == 0 ? Colors.red.withOpacity(0.75) : Colors.red;
        final yellow =
            total == 0 ? Colors.yellow.withOpacity(0.75) : Colors.yellow;

        return Container(
          decoration: decoration,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.favorite, color: yellow),
                    onPressed: star,
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.yellow.withOpacity(0.2))),
                    label: Text(
                      total == 0 ? 'Star' : 'Star ($total)',
                      style: TextStyle(
                          color: yellow, fontWeight: FontWeight.normal),
                    )),
                TextButton.icon(
                  icon: Icon(Icons.delete, color: red),
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(red.withOpacity(0.2))),
                  onPressed: delete,
                  label: Text(total == 0 ? 'Delete' : 'Delete ($total)',
                      style:
                          TextStyle(color: red, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
