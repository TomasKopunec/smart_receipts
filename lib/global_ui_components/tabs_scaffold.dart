import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/nav_bar_provider.dart';

import '../screens/tabs/abstract_tab_screen.dart';
import '../screens/tabs/add_receipt_screen.dart';
import '../screens/tabs/all_receipts_screen.dart';
import '../screens/tabs/dashboard_screen.dart';
import '../screens/tabs/groups_screen.dart';
import '../screens/tabs/settings_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  const TabsScaffold({super.key});

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  void _selectPage(int index) {
    Provider.of<NavBarProvider>(context, listen: false).selectPage(index);
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
    return Consumer<NavBarProvider>(
      builder: (ctx, provider, child) {
        return Scaffold(
          appBar: null,
          body: provider.selectedScreen,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: provider.isNavBarShown()
              ? BottomNavigationBar(
                  items: provider.items,
                  onTap: _selectPage,
                  currentIndex: provider.selectedIndex,
                  type: BottomNavigationBarType.shifting,
                  selectedItemColor: Colors.white,
                  selectedIconTheme: IconThemeData(
                      opacity: 1, size: getSelectedHeight(context)),
                  unselectedItemColor: Colors.white,
                  unselectedIconTheme: IconThemeData(
                      opacity: 0.6, size: getUnselectedHeight(context)),
                )
              : null,
        );
      },
    );
  }
}
