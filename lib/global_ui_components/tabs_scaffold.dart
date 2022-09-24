import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

import '../screens/tabs/abstract_tab_screen.dart';
import '../screens/tabs/add_receipt_screen.dart';
import '../screens/tabs/all_receipts_screen.dart';
import '../screens/tabs/dashboard_screen.dart';
import '../screens/tabs/groups_screen.dart';
import '../screens/tabs/settings_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  late List<AbstractTabScreen> _screens;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _screens = [
      AllReceiptsScreen(),
      DashboardScreen(),
      AddReceiptScreen(),
      GroupsScreen(),
      SettingsScreen()
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  double getSelectedHeight(BuildContext context) {
    final double screenHeight = SizeHelper.getScreenHeight(context);
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? screenHeight * 0.0375
        : screenHeight * 0.075;
  }

  double getUnselectedHeight(BuildContext context) {
    return getSelectedHeight(context) * 0.85;
  }

  @override
  Widget build(BuildContext context) {
    final AbstractTabScreen selectedScreen = _screens[_selectedPageIndex];

    return Scaffold(
      appBar: null,
      body: selectedScreen,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: _screens.map((screen) => screen.getAppBarItem()).toList(),
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        selectedIconTheme:
            IconThemeData(opacity: 1, size: getSelectedHeight(context)),
        unselectedItemColor: Colors.white,
        unselectedIconTheme:
            IconThemeData(opacity: 0.6, size: getUnselectedHeight(context)),
      ),
    );
  }
}
