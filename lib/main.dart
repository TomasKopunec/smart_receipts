import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';
import 'package:smart_receipts/screens/tab_control/tabs_scaffold.dart';
import 'screens/home.dart';

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
          ChangeNotifierProvider.value(value: AuthProvider()),
          ChangeNotifierProvider.value(value: ScreenProvider()),
          ChangeNotifierProvider.value(value: ReceiptsProvider()),
          ChangeNotifierProvider.value(value: SettingsProvider()),
          ChangeNotifierProvider.value(value: UserProvider()),
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return MaterialApp(
              title: 'Digital Receipts',
              debugShowCheckedModeBanner: false,
              themeMode: settings.theme == ThemeSetting.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: ThemeData(
                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                }),
                primarySwatch: Colors.teal,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 236, 236, 236),
                indicatorColor: const Color.fromARGB(255, 57, 57, 57),
                primaryColor: Colors.teal,
              ),
              darkTheme: ThemeData.dark().copyWith(
                  pageTransitionsTheme: const PageTransitionsTheme(builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                  }),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  scaffoldBackgroundColor:
                      const Color.fromARGB(255, 34, 34, 34),
                  indicatorColor: const Color.fromARGB(255, 236, 236, 236),
                  primaryColor: Colors.teal,
                  elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal))),
                  textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal)))),
              home: TabsScaffold(), // const Home(),
              routes: getRoutes(),
            );
          },
        ));
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
