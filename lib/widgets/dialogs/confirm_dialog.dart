import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<ElevatedButton> buttons;

  ConfirmDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 4, bottom: 8),
      contentPadding: EdgeInsets.zero,
      iconPadding: const EdgeInsets.only(top: 8),
      insetPadding: EdgeInsets.zero,
      icon: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w800),
      ),
      content: Container(
          width: SizeHelper.getScreenWidth(context) * 0.8,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  subtitle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: buttons
                        .map((e) => Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeHelper.getScreenWidth(context) *
                                          0.05),
                              child: e,
                            )))
                        .toList()),
              )
            ],
          )),
    );
  }
}
