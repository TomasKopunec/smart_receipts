import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/animated_toggle.dart';
import 'package:smart_receipts/widgets/control_header/date_range_entry.dart';
import 'package:smart_receipts/widgets/control_header/search_bar.dart';

import 'sorting_selection.dart';

class ControlHeaderBuilder {
  final List<Widget> _widgets = [];

  // SEARCH BAR
  ControlHeaderBuilder withReceiptSearchBar() {
    addWidget(Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) => SearchBar(
        onValueChanged: provider.setFilterValue,
        hintText: () => "Receipt's ${provider.searchKey.toString()}",
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withReturnsSearchBar() {
    addWidget(Consumer<ReturnsProvider>(
      builder: (ctx, provider, _) => SearchBar(
        onValueChanged: provider.setFilterValue,
        hintText: () => "Returns's ${provider.searchKey.toString()}",
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withFavouriteToggle(BuildContext context) {
    addWidget(Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) => AnimatedToggle(
        width: SizeHelper.getScreenWidth(context),
        animDuration: const Duration(milliseconds: 750),
        values: const ['ALL', 'FAVOURITE'],
        buttonColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).focusColor,
        textColor: Colors.white,
        isInitialValue: true,
        onValueChange: (value) {
          provider.toggleFavourites();
        },
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withReceiptSorting() {
    addWidget(Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) => SortingSelection(
        searchableKeys: Receipt.getSearchableKeys(),
        onSelected: (value) => provider.setSearchKey(value),
        getSortStatus: () => provider.sortStatus,
        getValue: () => provider.searchKey,
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withReturnsSorting() {
    addWidget(Consumer<ReturnsProvider>(
      builder: (ctx, provider, _) => SortingSelection(
        searchableKeys: Return.getSearchableKeys(),
        onSelected: (value) => provider.setSearchKey(value),
        getSortStatus: () => provider.sortStatus,
        getValue: () => provider.searchKey,
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withReceiptRangeSelection(BuildContext context) {
    _widgets.add(Consumer2<ReceiptsProvider, SettingsProvider>(
      builder: (ctx, receipts, settings, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DateRangeEntry(
            context: context,
            isStart: true,
            dateFormat: settings.dateTimeFormat,
            dateTime: receipts.startRangeDate,
            onSelected: receipts.setStartRangeDate,
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_right_alt),
          const SizedBox(width: 10),
          DateRangeEntry(
            context: context,
            isStart: false,
            dateFormat: settings.dateTimeFormat,
            dateTime: receipts.endRangeDate,
            onSelected: receipts.setEndRangeDate,
          )
        ],
      ),
    ));
    return this;
  }

  ControlHeaderBuilder withReturnRangeSelection(BuildContext context) {
    _widgets.add(Consumer2<ReturnsProvider, SettingsProvider>(
      builder: (ctx, receipts, settings, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DateRangeEntry(
            context: context,
            isStart: true,
            dateFormat: settings.dateTimeFormat,
            dateTime: receipts.startRangeDate,
            onSelected: receipts.setStartRangeDate,
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_right_alt),
          const SizedBox(width: 10),
          DateRangeEntry(
            context: context,
            isStart: false,
            dateFormat: settings.dateTimeFormat,
            dateTime: receipts.endRangeDate,
            onSelected: receipts.setEndRangeDate,
          )
        ],
      ),
    ));
    return this;
  }

  void addWidget(Widget widget) {
    _widgets.add(widget);
    _widgets.add(const SizedBox(height: 12));
  }

  Widget build(BuildContext context, bool isLoading) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        Container(
          child: ExpandablePanel(
              collapsed: Container(),
              controller: ExpandableController(initialExpanded: false),
              theme: const ExpandableThemeData(
                iconPadding: EdgeInsets.only(right: 12, top: 12),
                bodyAlignment: ExpandablePanelBodyAlignment.center,
                tapBodyToCollapse: false,
                animationDuration: Duration(milliseconds: 450),
                fadeCurve: Curves.fastLinearToSlowEaseIn,
              ),
              header: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 24, right: 0, bottom: 12),
                child: Center(
                  child: Text(
                    "Control Panel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          SizeHelper.getFontSize(context, size: FontSize.large),
                      color: Theme.of(context).indicatorColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              expanded: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 4),
                    child: Column(
                      children: _widgets,
                    ),
                  ),
                ],
              )),
        ),
        if (isLoading)
          LinearProgressIndicator(
            minHeight: SizeHelper.getScreenHeight(context) * 0.007,
          )
      ],
    );
  }
}
