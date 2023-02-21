import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';

class EntryDismissible extends StatelessWidget {
  final String id;
  final Widget child;
  final Color color;

  const EntryDismissible(
      {required this.child, required this.color, required this.id});

  void _star(BuildContext context) {
    Provider.of<ReceiptsProvider>(context, listen: false).flipFavorite(id);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(id),
      enabled: true,
      direction: Axis.horizontal,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(8),
            onPressed: (ctx) => _star(context),
            backgroundColor: const Color.fromARGB(255, 255, 187, 0),
            foregroundColor: Colors.white,
            icon: Icons.star,
            label: 'Star',
          ),
        ],
      ),
      child: child,
    );
  }
}
