import 'package:flutter/material.dart';

enum FontSize { SMALLER, SMALL, REGULAR, LARGE, LARGER }

class SizeHelper {
  static double getScreenHeight(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return screenSizeHeight - statusBarHeight;
  }

  static double getTopPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getFontSize(BuildContext context, {FontSize? size}) {
    final query = MediaQuery.of(context).size;
    final double ref = (query.width + query.height) / 2;

    final double regularSize = ref * 0.025;
    if (size == null) {
      return regularSize;
    }

    switch (size) {
      case FontSize.SMALLER:
        return regularSize * 0.5;
      case FontSize.SMALL:
        return regularSize * 0.75;
      case FontSize.REGULAR:
        return regularSize;
      case FontSize.LARGE:
        return regularSize * 1.25;
      case FontSize.LARGER:
        return regularSize * 1.5;
    }
  }
}
