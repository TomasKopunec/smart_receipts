import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

import 'sorting_selection_dropdown.dart';

class SortingSelection extends StatelessWidget {
  final List<dynamic> searchableKeys;
  final Function(dynamic value) onSelected;
  final Function() getSortStatus;
  final Function() getValue;

  const SortingSelection({
    super.key,
    required this.searchableKeys,
    required this.onSelected,
    required this.getSortStatus,
    required this.getValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SORT BY:',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.regular)),
            ),
            const SizedBox(
              width: 16,
            ),
            SortingSelectionDropdown(
              items: searchableKeys,
              onSelected: onSelected,
              getValue: getValue,
              getSortStatus: getSortStatus,
            ),
          ],
        ),
      ),
    );
  }
}
