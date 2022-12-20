import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/widgets/dialogs/confirm_dialog.dart';

class EntryDismissible extends StatelessWidget {
  final int id;
  final Widget child;
  final Color color;

  const EntryDismissible(
      {required this.child, required this.color, required this.id});

  void _delete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
          title: 'Delete Receipt',
          subtitle: 'Are you sure you want to remove this receipt?',
          color: color,
          width: SizeHelper.getScreenWidth(context) * 0.9),
    );

    if (result) {
      print('Removing receipt with uid: 1001');
    }
  }

  void _star(BuildContext context) {
    Provider.of<ReceiptsProvider>(context, listen: false).flipFavorite(id);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(id),
      enabled: true,
      direction: Axis.horizontal,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            autoClose: true,
            onPressed: (ctx) => _delete(context),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
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
