import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';
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
        ],
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return MaterialApp(
              title: 'Flutter Demo',
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
                indicatorColor: const Color.fromARGB(255, 46, 46, 46),
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
              home: const Home(),
              routes: getRoutes(),
            );
          },
        ));
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
