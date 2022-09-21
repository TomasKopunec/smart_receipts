import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';

class PlaygroundScreen extends StatelessWidget {
  static const route = '/playground';

  @override
  Widget build(BuildContext context) {
    return ReturnableScreen(
        title: 'Returnable Screen',
        appbarColor: const Color.fromRGBO(103, 125, 220, 1),
        body: Center(
          child: getReceiptView(),
        ));
  }

  Widget getReceiptView() {
    return Card(
      elevation: 4,
      child: ExpansionTile(
        // trailing: Text("Trailing"),
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

    /*return Card(
      child: Padding(
        padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
        child: ExpansionTile(
          title: Text('Birth of Universe'),
          children: [
            Text('Big Bang'),
            Text('Birth of the Sun'),
            Text('Earth is Born'),
          ],
        ),
      ),
    ); */
  }
}
