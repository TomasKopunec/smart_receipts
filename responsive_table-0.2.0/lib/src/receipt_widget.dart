import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReceiptWidget extends StatelessWidget {
  final String id;
  final Color color;

  const ReceiptWidget({required this.id, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: color,
      elevation: 4,
      child: ExpansionTile(
        leading: Text("Leading"),
        title: Text("Title"),
        subtitle: Text("Subtitle"),
        children: [
          ListTile(title: Text("Title 1")),
          ListTile(title: Text("Title 2")),
          ListTile(title: Text("Title 3")),
        ],
      ),
    );
  }
}
