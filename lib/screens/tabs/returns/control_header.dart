import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/models/return/return.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/widgets/control_header/sorting_selection.dart';
import '../../../widgets/control_header/search_bar.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          // Search Bar
          const SizedBox(height: 10),

          Consumer<ReturnsProvider>(
            builder: (ctx, provider, _) => SearchBar(
              onValueChanged: (value) => provider.setFilterValue(value),
              hintText: () => provider.searchKey.toString(),
            ),
          ),

          const SizedBox(height: 10),

          // Sorting
          Consumer<ReturnsProvider>(
            builder: (ctx, provider, _) => SortingSelection(
              searchableKeys: Return.getSearchableKeys(),
              onSelected: (value) => provider.setSearchKey(value),
              getSortStatus: () => provider.sortStatus,
              getValue: () => provider.searchKey,
            ),
          ),
        ],
      ),
    );
  }
}
