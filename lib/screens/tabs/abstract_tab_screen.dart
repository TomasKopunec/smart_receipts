import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

abstract class AbstractTabScreen extends StatelessWidget {
  final Color appColor = const Color.fromRGBO(81, 198, 157, 1);

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

  String getTitle();

  @nonVirtual
  Color get activeColor {
    return Colors.black;
  }

  IconData getIcon();
}
