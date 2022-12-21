import 'package:flutter/material.dart';

import '../screens/tab_control/abstract_tab_screen.dart';
import '../screens/tabs/add_receipt_screen.dart';
import '../screens/tabs/all_receipts/all_receipts_screen.dart';
import '../screens/tabs/returns_screen.dart';
import '../screens/tabs/home/home_screen.dart';
import '../screens/tabs/settings_screen.dart';

class ScreenProvider with ChangeNotifier {
  final List<AbstractTabScreen> _screens = [
    HomeScreen(),
    AllReceiptsScreen(),
    ReturnsScreen(),
    SettingsScreen(),
    AddReceiptScreen()
  ];

  int _selectedIndex = 0;

  List<AbstractTabScreen> get screens {
    return [..._screens];
  }

  void setSelectedIndex(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  AbstractTabScreen get selectedScreen {
    return _screens[_selectedIndex];
  }
}
