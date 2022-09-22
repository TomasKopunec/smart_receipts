import 'package:flutter/material.dart';

import '../../helpers/size_helper.dart';

class SearchBar extends StatefulWidget {
  final String searchKey;
  final Function(String) filter;
  final IconData searchIcon;
  final Duration duration;
  final double width;
  final Color color;

  const SearchBar(
      {required this.searchKey,
      required this.color,
      required this.filter,
      required this.searchIcon,
      required this.width,
      this.duration = const Duration(milliseconds: 400)});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isForward = true;

  final FocusNode _inputFocusNode = FocusNode();

  final textController = TextEditingController();

  /// Animation stuff
  late Animation<double> widthAnimation;
  late AnimationController widthAnimationController;

  @override
  void initState() {
    super.initState();

    // Animation
    widthAnimationController =
        AnimationController(vsync: this, duration: widget.duration);

    final curvedAnimation = CurvedAnimation(
        parent: widthAnimationController, curve: Curves.fastOutSlowIn);

    widthAnimation =
        Tween<double>(begin: 0, end: widget.width).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final double borderRadius = widget.width * 0.09;

    final Color selectedColor = widget.color.withOpacity(0.75);

    const Icon selectedIcon = Icon(Icons.check, color: Colors.white);
    final Icon unselectedIcon = Icon(widget.searchIcon, color: widget.color);

    const Curve opacityCurve = Curves.linear;
    final Duration opacityDuration = widget.duration * 1;

    textController.addListener(() {
      setState(() {
        widget.filter(textController.text);
      });
    });

    return Row(
      children: [
        AnimatedOpacity(
          curve: opacityCurve,
          opacity: !_isForward ? 1 : 0,
          duration: opacityDuration,
          child: Container(
            width: widthAnimation.value,
            decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius))),
            child: Row(
              children: [
                Flexible(
                  child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      textController.clear();
                    },
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    focusNode: _inputFocusNode,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      _trigger();
                      widget.filter(value);
                    },
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.regularSmall)),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        border: InputBorder.none,
                        hintText:
                            'Enter ${widget.searchKey.replaceAll(RegExp('[\\W_]+'), ' ').toUpperCase()}'),
                  ),
                )
              ],
            ),
          ),
        ),
        Stack(
          children: [
            AnimatedOpacity(
              curve: opacityCurve,
              opacity: !_isForward ? 1 : 0,
              duration: opacityDuration,
              child: Container(
                decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(0),
                      topLeft: const Radius.circular(0),
                      bottomRight: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    )),
                child: IconButton(
                  icon: Icon(widget.searchIcon, color: Colors.transparent),
                  onPressed: () {},
                ),
              ),
            ),
            IconButton(
                icon: !_isForward ? selectedIcon : unselectedIcon,
                onPressed: _trigger)
          ],
        ),
      ],
    );
  }

  void _trigger() {
    if (_isForward) {
      widthAnimationController.forward();
      _isForward = false;
      FocusManager.instance.primaryFocus!.requestFocus(_inputFocusNode);
    } else {
      widthAnimationController.reverse();
      _isForward = true;
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
}
