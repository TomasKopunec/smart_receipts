import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../screens/tabs/abstract_tab_screen.dart';
import '../screens/tabs/add_receipt_screen.dart';
import '../screens/tabs/all_receipts_screen.dart';
import '../screens/tabs/dashboard_screen.dart';
import '../screens/tabs/groups_screen.dart';
import '../screens/tabs/settings_screen.dart';

class NavBarProvider with ChangeNotifier {
  final List<AbstractTabScreen> _screens = [
    AllReceiptsScreen(),
    DashboardScreen(),
    AddReceiptScreen(),
    GroupsScreen(),
    SettingsScreen()
  ];

  List<AbstractTabScreen> get screens {
    return [..._screens];
  }

  int _selectedPageIndex = 0;

  void selectPage(int index) {
    _selectedPageIndex = index;

    notifyListeners();
  }

  int get selectedIndex {
    return _selectedPageIndex;
  }

  List<PersistentBottomNavBarItem> get items {
    return _screens.map((screen) => screen.getAppBarItem()).toList();
  }

  AbstractTabScreen get selectedScreen {
    return _screens[_selectedPageIndex];
  }
}
