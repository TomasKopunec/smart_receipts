import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/currency_dropdown_button.dart';
import 'package:smart_receipts/widgets/datetime_dropdown_button.dart';
import 'package:smart_receipts/widgets/animated_toggle.dart';
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
        getThemeSettings(provider),
        getCurrencySettings(),
        getDateTimeSettings(),
        getAccountSettings(),
      ],
    );
  }

  Widget getDigitalOnlySettings(SettingsProvider provider) {
    return getSettingsSection(
        'Digital receipt only',
        ToggleSelection(
          defaultState: provider.digitalOnly,
          onToggle: (val) {
            provider.setDigitalOnly(val);
          },
        ));
  }

  Widget getThemeSettings(SettingsProvider provider) {
    return getSettingsSection(
        'Theme',
        Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedToggle(
            width: SizeHelper.getScreenWidth(context),
            values: ThemeSetting.values.map((e) => e.name).toList(),
            backgroundColor: Colors.black.withOpacity(0.25),
            textColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.75),
            isInitialValue: provider.theme == ThemeSetting.light,
            onValueChange: (value) {
              provider.selectTheme(ThemeSetting.from(value));
              print('Theme changing to: ${value}');
            },
          ),
        ));
  }

  Widget getCurrencySettings() {
    return getSettingsSection(
        'Currency',
        CurrencyDropdownButton(
            textColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).canvasColor,
            width: SizeHelper.getScreenWidth(context)));
  }

  Widget getDateTimeSettings() {
    return getSettingsSection(
        'Date and Time Format',
        DateTimeDropdownButton(
          textColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).canvasColor,
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
            color: Theme.of(context).canvasColor,
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        body
      ],
    );
  }
}
