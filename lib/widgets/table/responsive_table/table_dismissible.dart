import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/widgets/dialogs/confirm_dialog.dart';

class TableDismissible extends StatelessWidget {
  final Key key;
  final Widget child;
  final Color color;

  const TableDismissible(
      {required this.key, required this.child, required this.color});

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

  void _star() {
    print('Staring receipt with uid: 1001');
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
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
            onPressed: (ctx) => _star(),
            backgroundColor: const Color.fromRGBO(250, 220, 0, 1),
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
