import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/control_header/sorting_selection.dart';
import 'package:smart_receipts/widgets/dialogs/dialog_helper.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import '../../../helpers/size_helper.dart';
import '../../../widgets/animated_toggle.dart';
import '../../../widgets/control_header/search_bar.dart';

class ControlHeader extends StatelessWidget {
  final bool isLoading;

  const ControlHeader({
    super.key,
    required this.isLoading,
  });

  Widget getSearchControls(context, ReceiptsProvider provider) {
    final color = Theme.of(context).primaryColor;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Column(
            children: [
              // Search Bar
              const SizedBox(height: 10),

              Consumer<ReceiptsProvider>(
                builder: (ctx, provider, _) => SearchBar(
                  onValueChanged: (value) => provider.setFilterValue(value),
                  hintText: () => "Receipts's ${provider.searchKey.toString()}",
                ),
              ),

              const SizedBox(height: 10),

              // Toggle Switch
              AnimatedToggle(
                width: SizeHelper.getScreenWidth(context),
                animDuration: const Duration(milliseconds: 750),
                values: const ['ALL', 'FAVOURITE'],
                buttonColor: color,
                backgroundColor: Theme.of(context).focusColor,
                textColor: Colors.white,
                isInitialValue: true,
                onValueChange: (value) {
                  provider.toggleFavourites();
                },
              ),

              const SizedBox(height: 12),

              // Sorting
              Consumer<ReceiptsProvider>(
                builder: (ctx, provider, _) => SortingSelection(
                  searchableKeys: Receipt.getSearchableKeys(),
                  onSelected: (value) => provider.setSearchKey(value),
                  getSortStatus: () => provider.sortStatus,
                  getValue: () => provider.searchKey,
                ),
              ),

              const SizedBox(height: 15),

              // Range Selection
              Consumer2<ReceiptsProvider, SettingsProvider>(
                builder: (ctx, receipts, settings, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    dateRangeEntry(
                      context: context,
                      isStart: true,
                      dateFormat: settings.dateTimeFormat,
                      dateTime: receipts.startRangeDate,
                      onSelected: receipts.setStartRangeDate,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_right_alt),
                    const SizedBox(width: 10),
                    dateRangeEntry(
                      context: context,
                      isStart: false,
                      dateFormat: settings.dateTimeFormat,
                      dateTime: receipts.endRangeDate,
                      onSelected: receipts.setEndRangeDate,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          LinearProgressIndicator(
            minHeight: SizeHelper.getScreenHeight(context) * 0.007,
          )
      ],
    );
  }

  Widget dateRangeEntry({
    required BuildContext context,
    required bool isStart,
    required DateTime dateTime,
    required DateTimeFormat dateFormat,
    required Function(DateTime) onSelected,
  }) {
    return Expanded(
      child: Center(
        child: Material(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () async {
              final selected = await DialogHelper.showDatePickerDialog(
                  context, dateTime, isStart);
              if (selected != null) {
                onSelected(selected);
              }
            },
            splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isStart ? "Start Date" : "End Date",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).indicatorColor,
                            fontSize: SizeHelper.getFontSize(
                              context,
                              size: FontSize.regularLarge,
                            )),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      DateFormat(dateFormat.format).format(dateTime),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).indicatorColor,
                          fontSize: SizeHelper.getFontSize(
                            context,
                            size: FontSize.regular,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSelectionControls(context, provider) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0, top: 8),
      child: const SelectionWidget(),
    );
  }

  Widget getControls(context, ReceiptsProvider provider) {
    return provider.isSelecting
        ? getSelectionControls(context, provider)
        : getSearchControls(context, provider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(builder: (ctx, provider, child) {
      return getControls(context, provider);
    });
  }
}
