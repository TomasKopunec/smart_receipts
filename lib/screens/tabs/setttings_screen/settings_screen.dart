import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings_provider.dart';
import 'package:smart_receipts/widgets/currency_dropdown_button.dart';
import 'package:smart_receipts/widgets/datetime_dropdown_button.dart';
import 'package:smart_receipts/widgets/receipt_dropdown_button.dart';
import 'package:smart_receipts/widgets/favourite_toggle.dart';
import 'package:smart_receipts/widgets/settings_dropdown_button.dart';
import 'package:smart_receipts/widgets/toggle_switch.dart';

import '../../tab_control/abstract_tab_screen.dart';

class SettingsScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Settings';
  }

  @override
  IconData getIcon() {
    return Icons.settings;
  }

  @override
  State<StatefulWidget> createState() => _SettingsState();

  @override
  String getIconTitle() {
    return 'Settings';
  }
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (ctx, provider, child) {
        return widget.getScreen(screenBody: getScreenBody(provider));
      },
    );
  }

  Widget getScreenBody(SettingsProvider provider) {
    return Column(
      children: [
        getDigitalOnlySettings(provider),
        getThemeSettings(),
        getCurrencySettings(),
        getDateTimeSettings(),
        getAccountSettings(),
      ],
    );
  }

  Widget getDigitalOnlySettings(provider) {
    return getSettingsSection('Digital receipt only',
        ToggleSelection(defaultState: provider.digitalOnly));
  }

  Widget getThemeSettings() {
    return getSettingsSection(
        'Theme',
        Padding(
          padding: const EdgeInsets.all(12),
          child: FavouriteToggle(
            width: SizeHelper.getScreenWidth(context),
            values: const ['Dark', 'Light'],
            backgroundColor: Colors.black.withOpacity(0.25),
            textColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.75),
          ),
        ));
  }

  Widget getCurrencySettings() {
    return getSettingsSection(
        'Currency',
        CurrencyDropdownButton(
            textColor: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            width: SizeHelper.getScreenWidth(context)));
  }

  Widget getDateTimeSettings() {
    return getSettingsSection(
        'Date and Time Format',
        DateTimeDropdownButton(
          textColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          width: SizeHelper.getScreenWidth(context),
        ));
  }

  Widget getAccountSettings() {
    return getSettingsSection(
        'Account Settings',
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            print('Change password pressed!');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Change Password')),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 226, 85, 75)),
                          onPressed: () {
                            print('Delete account pressed!');
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete Account')),
                    ),
                  ],
                ),
              ]),
        ));
  }

  Widget getSettingsSection(String title, Widget body) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            title,
            textAlign: TextAlign.start,
          ),
        ),
        body
      ],
    );
  }
}