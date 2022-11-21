import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smart_receipts/helpers/color_helper.dart';

import '../../helpers/size_helper.dart';

abstract class AbstractTabScreen extends StatefulWidget {
  @nonVirtual
  PersistentBottomNavBarItem getAppBarItem(BuildContext context) {
    return PersistentBottomNavBarItem(
        title: getTitle(),
        icon: Icon(getIcon()),
        activeColorPrimary: getColor(context),
        inactiveColorPrimary: activeColor.withOpacity(0.4),
        activeColorSecondary: activeColor,
        inactiveColorSecondary: Colors.red);
  }

  @nonVirtual
  Color getColor(BuildContext context) {
    return Theme.of(context).primaryColor; // ColorHelper.APP_COLOR;
  }

  @nonVirtual
  Color get activeColor {
    return Colors.black;
  }

  @nonVirtual
  Widget getTitleWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Container(
        color: Colors.pink,
        margin: EdgeInsets.only(top: SizeHelper.getTopPadding(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(getIcon()),
            Text(getTitle()),
          ],
        ),
      ),
    );
  }

  String getTitle();

  IconData getIcon();
}
