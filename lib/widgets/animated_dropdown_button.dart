import 'package:flutter/material.dart';
import 'package:smart_receipts/models/receipt.dart';

class AnimatedDropdownButton extends StatefulWidget {
  final Color color;
  final List<String> items;
  final String selected;

  const AnimatedDropdownButton(
      {required this.items, required this.selected, required this.color});

  @override
  State<AnimatedDropdownButton> createState() => _AnimatedDropdownButtonState();
}

class _AnimatedDropdownButtonState extends State<AnimatedDropdownButton> {
  late String selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.color.withOpacity(0.8),
      ),
      child: DropdownButtonHideUnderline(
          child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          dropdownColor: Colors.white,
          iconEnabledColor: Colors.white.withOpacity(0.8),
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
          value: widget.selected,
          // hint: Text('Select something'),
          onChanged: (value) {
            setState(() {
              selected = value as String;
            });
          },
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              child: Text(
                item,
                style: TextStyle(color: Colors.black),
              ),
              value: item,
            );
          }).toList(),
        ),
      )),
    );
  }
}
