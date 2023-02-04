import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/constants/image_strings.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/screens/auth/authentication_screen.dart';
import 'package:smart_receipts/screens/tab_control/tabs_scaffold.dart';
import 'package:smart_receipts/utils/shared_preferences_helper.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  final Function onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final token = await SharedPreferencesHelper.getToken();

      if (token != null) {
        print('Authenticated. Token: ${token.toJson()}');
        auth.setToken(token);
      } else {
        print('Unauthenticated.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      animationDuration: const Duration(seconds: 2),
      curve: Curves.fastLinearToSlowEaseIn,
      splash: const Image(image: AssetImage(splash)),
      splashIconSize: SizeHelper.getScreenHeight(context) * 0.45,
      splashTransition: SplashTransition.scaleTransition,
      duration: 2,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      screenFunction: () async {
        widget.onFinish();
        return Container();
      },
    );
  }
}
