import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/screens/auth/authentication_screen.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/screens/playgroundScreen.dart';
import 'package:smart_receipts/screens/tab_control/tabs_scaffold.dart';

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
        child: Consumer2<SettingsProvider, AuthProvider>(
          builder: (context, settings, auth, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              themeMode: settings.theme == ThemeSetting.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: ThemeData(
                primarySwatch: Colors.teal,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 236, 236, 236),
                indicatorColor: const Color.fromARGB(255, 46, 46, 46),
              ),
              darkTheme: ThemeData.dark().copyWith(
                primaryColor: Colors.teal,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor: const Color.fromARGB(255, 34, 34, 34),
                indicatorColor: const Color.fromARGB(255, 236, 236, 236),
              ),
              home: auth.signedIn ? TabsScaffold() : AuthenticationScreen(),
              routes: getRoutes(),
            );
          },
        ));
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {PlaygroundScreen.route: (ctx) => PlaygroundScreen()};
  }
}
