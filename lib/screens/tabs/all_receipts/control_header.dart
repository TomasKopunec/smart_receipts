import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/screens/tabs/all_receipts/search_bar.dart';
import 'package:smart_receipts/widgets/selection_widget.dart';

import '../../../helpers/size_helper.dart';
import 'favourite_toggle.dart';
import 'animated_dropdown_button.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key});

  Widget getSearchControls(context, provider) {
    final color = Theme.of(context).primaryColor;

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
            values: const ['ALL', 'FAVOURITE'],
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
                    width: SizeHelper.getScreenWidth(context) * 0.525,
                    color: Theme.of(context).primaryColor,
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
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 1.5,
                offset: const Offset(0, 1.5)),
          ],
        ),
        child: getControls(context, provider),
      );
    });
  }
}
