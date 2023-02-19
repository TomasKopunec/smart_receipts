import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> buttons;
  final Color color;
  final TextEditingController? input;

  ConfirmDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttons,
    required this.color,
    this.input,
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 4, bottom: 8),
      contentPadding: EdgeInsets.zero,
      iconPadding: const EdgeInsets.only(top: 8),
      insetPadding: EdgeInsets.zero,
      icon: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Icon(widget.icon, color: widget.color),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(
        widget.title,
        style: TextStyle(color: widget.color, fontWeight: FontWeight.w800),
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
                  widget.subtitle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              if (widget.input != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: TextFormField(
                    controller: widget.input,
                    validator: ((val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter your password";
                      }
                      if (val.length < 8) {
                        return "Password must have at least 8 characters";
                      }
                      return null;
                    }),
                    obscureText: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                        helperText: "Enter your password to confirm deletion",
                        border: OutlineInputBorder(),
                        hintText: "Enter your password",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        isDense: true),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widget.buttons
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
