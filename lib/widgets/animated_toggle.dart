import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final Duration animDuration;
  final bool isInitialValue;
  final Function(String value) onValueChange;

  const AnimatedToggle({
    required this.width,
    required this.values,
    required this.onValueChange,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = Colors.white,
    this.animDuration = const Duration(milliseconds: 1000),
    required this.isInitialValue,
  }) : assert(values.length <= 2);

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  late bool _initialPosition;

  @override
  void initState() {
    // TODO: implement initState
    _initialPosition = widget.isInitialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (ctx, provider, _) {
        return SizedBox(
          width: widget.width,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _initialPosition = !_initialPosition;
                  widget.onValueChange(
                      _initialPosition ? widget.values[0] : widget.values[1]);

                  // Rebuild
                  setState(() {});
                },
                child: Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    width: widget.width,
                    decoration: ShapeDecoration(
                      color: widget.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: widget.values
                          .map((label) => Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: SizeHelper.getFontSize(context,
                                      size: FontSize.regular),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: widget.animDuration,
                curve: Curves.fastLinearToSlowEaseIn,
                alignment: _initialPosition
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  margin: _initialPosition
                      ? const EdgeInsets.only(top: 2, left: 2)
                      : const EdgeInsets.only(top: 2, right: 2),
                  width: widget.width * 0.475,
                  decoration: ShapeDecoration(
                    color: widget.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initialPosition ? widget.values[0] : widget.values[1],
                    style: TextStyle(
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.regular),
                      color: widget.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
