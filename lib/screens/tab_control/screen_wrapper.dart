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

  Color getScreenColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.07), // Screen background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitleWidget(context, action),
          if (headerBody != null) headerBody!,
          SizedBox(
            height: 3,
          ),
          Expanded(
            child: screenBody,
          ),
        ],
      ),
    );
  }

  Widget _getTitleWidget(BuildContext context, Widget? action) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: SizeHelper.getTopPadding(context), right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: getScreenColor(context)),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              title,
              style: TextStyle(
                  color: getScreenColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.large)),
            ),
          ),
          action != null
              ? action
              : TextButton(onPressed: () {}, child: Text(''))
        ],
      ),
    );
  }
}
