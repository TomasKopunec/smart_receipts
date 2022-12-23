import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ToggleSelection extends StatefulWidget {
  final bool defaultState;
  final Function(bool)? onToggle;

  const ToggleSelection({super.key, this.onToggle, required this.defaultState});

  @override
  State<ToggleSelection> createState() => _ToggleSelectionState();
}

class _ToggleSelectionState extends State<ToggleSelection> {
  late bool _state;

  @override
  void initState() {
    _state = widget.defaultState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.25,
      child: Switch(
          activeColor: Theme.of(context).primaryColor,
          value: _state,
          onChanged: (val) {
            setState(() {
              _state = val;
            });
            if (widget.onToggle != null) {
              widget.onToggle!(val);
            }
          }),
    );
  }
}
