import 'dart:ui';

// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/nav_bar_provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/all_receipts_screen.dart';
import 'package:smart_receipts/screens/tabs/dashboard_screen.dart';
import 'package:smart_receipts/screens/tabs/groups_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  const TabsScaffold({super.key});

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  @override
  void initState() {
    // 1. Fetch all receipts
    final receiptsProvider =
        Provider.of<ReceiptsProvider>(context, listen: false);
    receiptsProvider.fetchAndSetReceipts();

    // 2. Fetch all favorites
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

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarProvider>(builder: (ctx, provider, _) {
      return PersistentTabView(
        context,
        backgroundColor: const Color.fromRGBO(235, 235, 235, 1),
        navBarStyle: NavBarStyle.style3,
        screens: provider.screens,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 300),
        ),
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        items: provider.items,
      );
    });
  }
}
