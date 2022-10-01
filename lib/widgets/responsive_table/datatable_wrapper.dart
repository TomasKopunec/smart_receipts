import 'package:flutter/material.dart';
import '../../../helpers/size_helper.dart';

class DatatableWrapper extends StatelessWidget {
  final Widget table;
  final Color color;

  const DatatableWrapper({required this.table, required this.color});

  @override
  Widget build(BuildContext context) {
    /// Wrapper for the table to provide nice padding and margins

    final verticalPadding = SizeHelper.getTopPadding(context);
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(top: verticalPadding),
            padding: EdgeInsets.zero,
            child: Card(
              elevation: 5,
              shadowColor: color,
              clipBehavior: Clip.none,
              child: table,
            ),
          )
        ],
      ),
    );
  }
}
