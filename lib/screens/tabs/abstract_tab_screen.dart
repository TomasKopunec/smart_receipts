import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class AbstractTabScreen extends StatelessWidget {
  @nonVirtual
  BottomNavigationBarItem getAppBarItem() {
    return BottomNavigationBarItem(
        backgroundColor: getColor(), icon: Icon(getIcon()), label: getTitle());
  }

  String getTitle();

  Color getColor();

  IconData getIcon();
}
