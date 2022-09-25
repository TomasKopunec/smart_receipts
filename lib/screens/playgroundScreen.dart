import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/returnable_screen.dart';
import 'package:smart_receipts/widgets/table/animated/animated_opacity_container.dart';
import 'package:smart_receipts/widgets/table/animated/animated_translation_container.dart';

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
    final Duration duration = Duration(seconds: 1);

    return AnimatedOpacityContainer(
      duration: duration,
      child: Card(
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
      ),
    );
  }
}
