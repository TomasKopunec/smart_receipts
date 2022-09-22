import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/global_ui_components/tabs_scaffold.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
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
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: ReceiptsProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // dividerColor: Colors.amber),
        home: TabsScaffold(), // PlaygroundScreen(),
        routes: getRoutes(),
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
