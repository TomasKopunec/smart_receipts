import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/screens/abstract_screen.dart';
import 'package:smart_receipts/screens/add_receipt_screen.dart';
import 'package:smart_receipts/screens/all_receipts_screen.dart';
import 'package:smart_receipts/screens/dashboard_screen.dart';
import 'package:smart_receipts/screens/groups_screen.dart';
import 'package:smart_receipts/screens/settings_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  late List<AbstractScreen> _screens;
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
    return Scaffold(
      appBar: null,
      body: _screens[_selectedPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: _screens.map((screen) => screen.getAppBarItem()).toList(),
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

  Widget getSampleScreen(String text) {
    return Scaffold(
      body: Center(child: Text(text)),
    );
  }
}
