import 'package:flutter/material.dart';

import '../../helpers/size_helper.dart';

class ScreenWrapper extends StatelessWidget {
  // Header
  final IconData icon;
  final String title;
  final Widget? action;
  final Widget? headerBody;
  final Widget screenBody;

  ScreenWrapper({
    super.key,
    required this.icon,
    required this.title,
    this.action,
    this.headerBody,
    Widget? screenBody,
  }) : this.screenBody = screenBody ?? Center(child: Text(title));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Theme.of(context).scaffoldBackgroundColor, // Screen background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitleWidget(context, action),
          if (headerBody != null)
            _getHeaderActionsWrapper(context, headerBody!),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1)),
          Expanded(
            child: screenBody,
          ),
        ],
      ),
    );
  }

  Widget _getTitleWidget(BuildContext context, Widget? action) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: EdgeInsets.only(
          top: SizeHelper.getTopPadding(context), right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.large)),
            ),
          ),
          action ?? TextButton(onPressed: () {}, child: const Text(''))
        ],
      ),
    );
  }

  Widget _getHeaderActionsWrapper(context, Widget body) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 1.5,
              offset: const Offset(0, 1.5)),
        ],
      ),
      child: body,
    );
  }
}
