import 'package:flutter/material.dart';

import 'abstract_tab_screen.dart';

class DashboardScreen extends AbstractTabScreen {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shadowColor: Colors.red,
        // elevation: 4,
        child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text("Zara | Bratislava, SK"),
          subtitle: Text("26th September, 2022"),
          trailing: Text("79.99\$"),
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                    onChanged: (value) {},
                    value: false,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                ],
              )
            ]),
          ],
        ),
      ),
    );
  }

  @override
  String getTitle() {
    return 'Dashboard';
  }

  @override
  Color getColor() {
    return const Color.fromRGBO(216, 30, 91, 1);
  }

  @override
  IconData getIcon() {
    return Icons.dashboard;
  }
}
