import 'package:flutter/material.dart';

class SizeHelper {
  static double getScreenHeight(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return screenSizeHeight - statusBarHeight;
  }
}
