import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smart_receipts/screens/tab_control/screen_wrapper.dart';

abstract class AbstractTabScreen extends StatefulWidget {
  const AbstractTabScreen({super.key});

  @nonVirtual
  PersistentBottomNavBarItem getAppBarItem(BuildContext context) {
    return PersistentBottomNavBarItem(
        title: getTitle(),
        icon: Icon(getIcon()),
        activeColorPrimary: getColor(context),
        inactiveColorPrimary: activeColor.withOpacity(0.4),
        activeColorSecondary: activeColor);
  }

  @nonVirtual
  Color getColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  @nonVirtual
  Color get activeColor {
    return Colors.black;
  }

  Widget getScreen({Widget? action, Widget? headerBody, Widget? screenBody}) {
    return ScreenWrapper(
        icon: getIcon(),
        title: getTitle(),
        action: action,
        headerBody: headerBody,
        screenBody: screenBody);
  }

  String getTitle();

  String getIconTitle();

  IconData getIcon();
}
