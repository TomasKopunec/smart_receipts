import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/screens/tab_control/tabs_scaffold.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings_provider.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Main());
  });
}

/// The starting point of the app
class Main extends StatelessWidget {
  Main() : super(key: UniqueKey());

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ScreenProvider()),
        ChangeNotifierProvider.value(value: ReceiptsProvider()),
        ChangeNotifierProvider.value(value: SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (_, settings, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: settings.theme == ThemeSetting.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: ThemeData(
              primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: Color.fromARGB(255, 236, 236, 236),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: Color.fromARGB(255, 34, 34, 34),
            ),
            home: const TabsScaffold(),
            routes: getRoutes(),
          );
        },
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
