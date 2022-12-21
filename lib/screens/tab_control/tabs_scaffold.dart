import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/add_receipt_screen.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/all_receipts_screen.dart';
import 'package:smart_receipts/screens/tabs/groups_screen.dart';
import 'package:smart_receipts/screens/tabs/home_screen.dart';
import 'package:smart_receipts/screens/tabs/settings_screen.dart';

import 'abstract_tab_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  const TabsScaffold({super.key});

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  final PageController _myPage = PageController(initialPage: 0);
  int _selectedIndex = 0;

  final List<AbstractTabScreen> _screens = [
    HomeScreen(),
    AllReceiptsScreen(),
    GroupsScreen(),
    SettingsScreen(),
    AddReceiptScreen()
  ];

  @override
  void initState() {
    // 1. Fetch all receipts
    final receiptsProvider =
        Provider.of<ReceiptsProvider>(context, listen: false);
    receiptsProvider.fetchAndSetReceipts();

    // 2. Fetch all favorites from local memory
    receiptsProvider.fetchAndSetFavorites();

    super.initState();
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

  void safeSetState(func) {
    if (mounted) {
      setState(() {
        func();
      });
    }
  }

  List<Widget> getMenuItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < 2; i++) {
      AbstractTabScreen screen = _screens[i];
      widgets.add(MenuItem(
          icon: screen.getIcon(),
          label: screen.getTitle(),
          isSelected: _selectedIndex == i,
          isDummy: false,
          changePage: () => safeSetState(() {
                _myPage.jumpToPage(i);
                _selectedIndex = i;
              })));
    }

    widgets.add(MenuItem(
        icon: Icons.abc,
        label: '',
        isSelected: false,
        isDummy: true,
        changePage: () {}));

    for (int i = 2; i < 4; i++) {
      AbstractTabScreen screen = _screens[i];
      widgets.add(MenuItem(
          icon: screen.getIcon(),
          label: screen.getTitle(),
          isSelected: _selectedIndex == i,
          isDummy: false,
          changePage: () => safeSetState(() {
                _myPage.jumpToPage(i);
                _selectedIndex = i;
              })));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _myPage,
        onPageChanged: (value) {
          print('Page changes to index $value');
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      floatingActionButton: SizedBox(
        width: SizeHelper.getScreenWidth(context) * 0.19,
        height: SizeHelper.getScreenWidth(context) * 0.19,
        child: FittedBox(
          child: FloatingActionButton(
            splashColor: Theme.of(context).primaryColor,
            elevation: 3,
            onPressed: (() {
              _myPage.jumpToPage(_screens.length - 1);
            }),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white.withOpacity(0.925),
              size: SizeHelper.getScreenWidth(context) * 0.065,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin:
              6, //notche margin between floating button and bottom appbar
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //children inside bottom appbar
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getMenuItems())),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function changePage;
  final bool isDummy;

  const MenuItem(
      {required this.icon,
      required this.label,
      required this.isSelected,
      required this.changePage,
      req,
      required this.isDummy});

  @override
  Widget build(BuildContext context) {
    double opacity = 0;
    if (!isDummy) {
      opacity = isSelected ? 1 : 0.5;
    }

    return Expanded(
      flex: isDummy ? 27 : 20,
      child: Opacity(
        opacity: opacity,
        child: Container(
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: isDummy
                ? null
                : () {
                    changePage();
                  },
            child: Container(
              padding: const EdgeInsets.only(top: 4, bottom: 6),
              decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.04)
                      : Colors.white,
                  //  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border(
                          top: BorderSide(
                              width: 3, color: Theme.of(context).primaryColor))
                      : const Border(
                          top:
                              BorderSide(width: 3, color: Colors.transparent))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      color: Theme.of(context).primaryColor,
                      size: SizeHelper.getScreenWidth(context) * 0.075),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
