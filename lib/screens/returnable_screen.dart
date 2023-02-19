import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';

/// Screen that can be returned (opened from Navigator push)
class ReturnableScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const ReturnableScreen({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: actions,
          ),
          body: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: body,
      ),
    );
  }
}
