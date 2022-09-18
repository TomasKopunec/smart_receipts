import 'package:flutter/material.dart';

enum FontSize {
  smallest,
  smaller,
  small,
  regularSmall,
  regular,
  regularLarge,
  large,
  larger,
  largest
}

class SizeHelper {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

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
      case FontSize.smallest:
        return regularSize * 0.45;
      case FontSize.smaller:
        return regularSize * 0.6;
      case FontSize.small:
        return regularSize * 0.75;
      case FontSize.regularSmall:
        return regularSize * 0.9;
      case FontSize.regular:
        return regularSize;
      case FontSize.regularLarge:
        return regularSize * 1.1;
      case FontSize.large:
        return regularSize * 1.25;
      case FontSize.larger:
        return regularSize * 1.4;
      case FontSize.largest:
        return regularSize * 1.65;
    }
  }
}
