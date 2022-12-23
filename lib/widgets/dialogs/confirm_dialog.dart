import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  // final bckgColor = const Color.fromRGBO(240, 240, 240, 1);

  final String title;
  final String subtitle;
  final double width;
  final Color color;

  ConfirmDialog(
      {required this.title,
      required this.subtitle,
      required this.color,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 4, bottom: 8),
      contentPadding: EdgeInsets.zero,
      iconPadding: const EdgeInsets.only(top: 8),
      insetPadding: EdgeInsets.zero,
      icon: Icon(Icons.delete, color: color),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
      content: Container(
          width: width,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: color),
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('No')),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: color),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Yes')),
                    ]),
              )
            ],
          )),
    );
  }
}
