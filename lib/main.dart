import 'package:flutter/material.dart';
import 'package:smart_receipts/global_ui_components/tabs_scaffold.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

/// The starting point of the app
class Main extends StatelessWidget {
  Main() : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsScaffold(),
      routes: getRoutes(),
    );
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
