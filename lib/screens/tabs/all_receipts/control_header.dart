import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/search_bar.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import '../../../helpers/size_helper.dart';
import '../../../utils/snackbar_builder.dart';
import 'favourite_toggle.dart';
import 'animated_dropdown_button.dart';

class ControlHeader extends StatelessWidget {
  final Color color;
  const ControlHeader({required this.color});

  Widget getTitle(context, provider) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: SizeHelper.getTopPadding(context), right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.receipt, color: color),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              'All receipts',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.large)),
            ),
          ),

          // Select Button
          if (MediaQuery.of(context).orientation == Orientation.portrait)
            TextButton(
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(color.withOpacity(0.2)),
                ),
                onPressed: () {
                  if (provider.receiptSize == 0) {
                    AppSnackBar.show(
                        context,
                        AppSnackBarBuilder()
                            .withText('No receipts available.')
                            .withDuration(const Duration(seconds: 3)));
                    return;
                  }

                  if (provider.isSelecting) {
                    provider.clearSelecteds(notify: true);
                  }

                  provider.toggleSelecting();
                },
                child: Text(
                  provider.isSelecting ? 'Cancel' : 'Select',
                  style: TextStyle(color: color),
                ))
        ],
      ),
    );
  }

  Widget getSearchControls(context, provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          // Search Bar
          const SizedBox(height: 10),
          SearchBar(),
          const SizedBox(height: 10),

          // Toggle Switch
          FavouriteToggle(
            width: SizeHelper.getScreenWidth(context),
            animDuration: const Duration(milliseconds: 750),
            values: const ['ALL', 'STARRED'],
            buttonColor: color,
            backgroundColor: Colors.black.withOpacity(0.1),
            textColor: Colors.white,
          ),

          const SizedBox(height: 10),

          // Sorting
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SORT BY:',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.regular)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  AnimatedDropdownButton(
                    width: SizeHelper.getScreenWidth(context) * 0.475,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectionControls(context, provider) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 12, top: 8),
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
      return Column(
        children: [getTitle(context, provider), getControls(context, provider)],
      );
    });
  }
}
