import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smart_receipts/helpers/color_helper.dart';

abstract class AbstractTabScreen extends StatefulWidget {
  @nonVirtual
  PersistentBottomNavBarItem getAppBarItem() {
    return PersistentBottomNavBarItem(
        title: getTitle(),
        icon: Icon(getIcon()),
        activeColorPrimary: appColor,
        inactiveColorPrimary: activeColor.withOpacity(0.4),
        activeColorSecondary: activeColor,
        inactiveColorSecondary: Colors.red);
  }

  @nonVirtual
  Color get appColor {
    return ColorHelper.APP_COLOR;
  }

  @nonVirtual
  Color get activeColor {
    return Colors.black;
  }

  String getTitle();

  IconData getIcon();
}
