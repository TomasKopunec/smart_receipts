import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/constants/image_strings.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';

import '../utils/loaders/on_startup_loader.dart';

class SplashScreen extends StatefulWidget {
  final Function onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    /// Load all neccessary resources
    OnStartupLoader(
        context: context,
        onLoad: () =>
            Future.delayed(const Duration(milliseconds: 500)).then((value) {
              setState(() {
                _isLoaded = true;
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? AnimatedSplashScreen.withScreenFunction(
            animationDuration: const Duration(seconds: 2),
            curve: Curves.fastLinearToSlowEaseIn,
            splash: Consumer<SettingsProvider>(
              builder: (ctx, settings, _) {
                return settings.theme == ThemeSetting.light
                    ? const Image(image: AssetImage(splashLight))
                    : const Image(image: AssetImage(splashDark));
              },
            ),
            splashIconSize: SizeHelper.getScreenHeight(context) * 0.45,
            splashTransition: SplashTransition.scaleTransition,
            duration: 2,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            screenFunction: () async {
              widget.onFinish();
              return Container();
            },
          )
        : Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Loading...",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )),
          );
  }
}
