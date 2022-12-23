import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

class FavouriteToggle extends StatefulWidget {
  final List<String> values;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final List<BoxShadow> shadows;
  final double width;
  final Duration animDuration;

  const FavouriteToggle({
    required this.width,
    required this.values,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = Colors.white,
    this.shadows = const [
      BoxShadow(
        color: Color(0xFFd8d7da),
        blurRadius: 3,
        offset: Offset(0, 2),
      ),
    ],
    this.animDuration = const Duration(milliseconds: 1000),
  }) : assert(values.length <= 2);

  @override
  _FavouriteToggleState createState() => _FavouriteToggleState();
}

class _FavouriteToggleState extends State<FavouriteToggle> {
  bool initialPosition = true;

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
                  initialPosition = !initialPosition;
                  provider.toggleFavourites();
                  setState(() {});
                },
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
              AnimatedAlign(
                duration: widget.animDuration,
                curve: Curves.fastLinearToSlowEaseIn,
                alignment: initialPosition
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  margin: initialPosition
                      ? const EdgeInsets.only(top: 2, left: 2)
                      : const EdgeInsets.only(top: 2, right: 2),
                  width: widget.width * 0.475,
                  decoration: ShapeDecoration(
                    color: widget.buttonColor,
                    shadows: widget.shadows,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initialPosition ? widget.values[0] : widget.values[1],
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
