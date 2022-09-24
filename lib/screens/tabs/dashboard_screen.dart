import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

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
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("79.99\$"),
              Container(
                  child: Text(
                    "ACTIVE",
                    style: TextStyle(
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.small)),
                  ),
                  margin: const EdgeInsets.only(top: 2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)))
            ],
          ),
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
