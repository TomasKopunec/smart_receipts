import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/screen_provider.dart.dart';
import 'package:smart_receipts/utils/loaders/on_signed_in_loader.dart';

import 'abstract_tab_screen.dart';

class TabsScaffold extends StatefulWidget {
  static const route = '/';

  const TabsScaffold({super.key});

  @override
  State<TabsScaffold> createState() => _TabsScaffoldState();
}

class _TabsScaffoldState extends State<TabsScaffold> {
  late final ScreenProvider screenProvider;
  late final PageController _myPage;

  @override
  void initState() {
    // 1. Initialize screen provider
    screenProvider = Provider.of<ScreenProvider>(context, listen: false);
    screenProvider.addListener(() {
      safeSetState(() {
        _myPage.jumpToPage(screenProvider.selectedIndex);
      });
    });

    // 2. Initialize page controller
    _myPage = PageController(initialPage: screenProvider.selectedIndex);

    // 3. Load the rest
    OnSignedInLoader(context: context, onLoad: () {});

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

  void changePage(int value) {
    safeSetState(() {
      _myPage.jumpToPage(value);
      screenProvider.setSelectedIndex(value);

      if (value == 4) {}
    });
  }

  List<Widget> getMenuItems() {
    List<Widget> widgets = [];
    for (int i = 0; i < 2; i++) {
      AbstractTabScreen screen = screenProvider.screens[i];
      widgets.add(MenuItem(
          icon: screen.getIcon(),
          label: screen.getIconTitle(),
          isSelected: screenProvider.selectedIndex == i,
          isDummy: false,
          changePage: () {
            changePage(i);
          }));
    }

    widgets.add(MenuItem(
        icon: Icons.abc,
        label: '',
        isSelected: false,
        isDummy: true,
        changePage: () {
          // Ignore
        }));

    for (int i = 2; i < 4; i++) {
      AbstractTabScreen screen = screenProvider.screens[i];
      widgets.add(MenuItem(
          icon: screen.getIcon(),
          label: screen.getTitle(),
          isSelected: screenProvider.selectedIndex == i,
          isDummy: false,
          changePage: () {
            changePage(i);
          }));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(Theme.of(context).primaryColor);
    final selectedColor =
        hsl.withLightness((hsl.lightness - 0.05).clamp(0.0, 1.0)).toColor();

    return Scaffold(
      body: PageView(
        controller: _myPage,
        onPageChanged: (value) {
          // ('Page changes to index $value');
        },
        physics: const NeverScrollableScrollPhysics(),
        children: screenProvider.screens,
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? SizeHelper.getScreenWidth(context) * 0.19
            : SizeHelper.getScreenWidth(context) * 0.08,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? SizeHelper.getScreenWidth(context) * 0.19
            : SizeHelper.getScreenWidth(context) * 0.08,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: (screenProvider.selectedIndex ==
                    (screenProvider.screens.length - 1))
                ? selectedColor
                : Theme.of(context).primaryColor,
            splashColor: selectedColor,
            elevation: 3,
            onPressed: () {
              changePage(screenProvider.screens.length - 1);
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: SizeHelper.getMenuIconSize(context),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          // Bottom navigation bar on scaffold
          color: Theme.of(context).canvasColor,
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

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.changePage,
    required this.isDummy,
  });

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
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).canvasColor,
                border: isSelected
                    ? Border(
                        top: BorderSide(
                            width: 3, color: Theme.of(context).primaryColor))
                    : const Border(
                        top: BorderSide(width: 3, color: Colors.transparent))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: Theme.of(context).primaryColor,
                    size: SizeHelper.getMenuIconSize(context)),
                Text(label)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
