import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget? titleAction;
  final Widget? body;
  const Section({super.key, required this.title, this.body, this.titleAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        // DEBUG color: Colors.red.withOpacity(0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [getTitle(context), body ?? const Text('Section content')],
        ),
      ),
    );
  }

  Widget getTitle(context) {
    Widget? titleWidget;

    if (titleAction == null) {
      return Text(
        title,
        style: TextStyle(
            fontSize: SizeHelper.getFontSize(context, size: FontSize.larger),
            fontWeight: FontWeight.w600),
      );
    } else {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize:
                    SizeHelper.getFontSize(context, size: FontSize.larger),
                fontWeight: FontWeight.w600),
          ),
          titleAction!
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 4, left: 8),
      child: titleWidget,
    );
  }
}
