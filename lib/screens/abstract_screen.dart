import 'package:flutter/material.dart';

abstract class AbstractScreen extends StatelessWidget {
  String getTitle();

  BottomNavigationBarItem getAppBarItem();

  Color getColor();
}
