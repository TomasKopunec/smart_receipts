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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [getTitle(context), body ?? const Text('Section content')],
      ),
    );
  }

  Widget getTitle(context) {
    Widget? titleWidget;

    if (titleAction == null) {
      titleWidget = Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      );
    } else {
      titleWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          titleAction!
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: titleWidget,
    );
  }
}
