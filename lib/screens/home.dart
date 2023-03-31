import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth/auth_provider.dart';
import '../utils/logger.dart';
import 'auth/authentication_screen.dart';
import 'splash_screen.dart';
import 'tab_control/tabs_scaffold.dart';

class Home extends StatefulWidget {
  final Logger logger = Logger(Home);
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _seenSplash = false;

  @override
  Widget build(BuildContext context) {
    widget.logger.log("Rebulding HOME | seenSplash: $_seenSplash");

    return _seenSplash
        ? Consumer<AuthProvider>(builder: (ctx, auth, _) {
            widget.logger.log(
                "Building Authenticated, isAuthenticated: ${auth.isAuthenticated}");
            return auth.isAuthenticated
                ? const TabsScaffold()
                : const AuthenticationScreen();
          })
        : SplashScreen(
            onFinish: () {
              setState(() {
                _seenSplash = true;
              });
            },
          );
  }
}
