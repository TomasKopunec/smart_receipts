import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/widgets/control_header/sorting_selection.dart';
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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
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
                backgroundColor: Colors.black.withOpacity(0.1),
                textColor: Colors.white,
                isInitialValue: true,
                onValueChange: (value) {
                  provider.toggleFavourites();
                },
              ),

              const SizedBox(height: 10),

              // Sorting
              Consumer<ReceiptsProvider>(
                builder: (ctx, provider, _) => SortingSelection(
                  searchableKeys: Receipt.getSearchableKeys(),
                  onSelected: (value) => provider.setSearchKey(value),
                  getSortStatus: () => provider.sortStatus,
                  getValue: () => provider.searchKey,
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
