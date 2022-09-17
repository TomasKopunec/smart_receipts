import 'package:flutter/material.dart';
import 'package:smart_receipts/global_ui_components/tabs_scaffold.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';

void main() {
  runApp(Main());
}

/// The starting point of the app
class Main extends StatelessWidget {
  Main() : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabsScaffold(),
      routes: getRoutes(),
    );
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
