import 'package:flutter/material.dart';

class ToggleSelection extends StatefulWidget {
  final bool defaultState;
  final bool enabled;
  final Function(bool)? onToggle;

  const ToggleSelection({
    super.key,
    this.onToggle,
    required this.defaultState,
    required this.enabled,
  });

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
          onChanged: widget.enabled
              ? (val) {
                  setState(() {
                    _state = val;
                  });
                  if (widget.onToggle != null) {
                    widget.onToggle!(val);
                  }
                }
              : null),
    );
  }
}
