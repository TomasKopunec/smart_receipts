import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/screens/tabs/home/recent_receipts.dart';
import 'package:smart_receipts/screens/tabs/home/sustainability_widget.dart';

import '../../tab_control/abstract_tab_screen.dart';

class HomeScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Home';
  }

  @override
  IconData getIcon() {
    return Icons.home;
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

  @override
  String getIconTitle() {
    return 'Home';
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.getScreen(headerBody: headerBody, screenBody: screenBody);
  }

  Widget get screenBody {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const SustainabilityWidget(), const RecentReceipts()],
    );
  }

  Widget get headerBody {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          SizedBox(width: 16),
          Text('Hello, ',
              style: TextStyle(
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.large),
                  fontWeight: FontWeight.w300)),
          Text('Tomas!',
              style: TextStyle(
                  fontSize:
                      SizeHelper.getFontSize(context, size: FontSize.large),
                  fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
