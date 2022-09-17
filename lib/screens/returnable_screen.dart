import 'package:flutter/material.dart';

/// Screen that can be returned (opened from Navigator push)
class ReturnableScreen extends StatelessWidget {
  final String title;
  final Color appbarColor;
  final Widget body;

  const ReturnableScreen(
      {required this.title, required this.appbarColor, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: appbarColor),
      body: body,
    );
  }
}
