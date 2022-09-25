import 'package:flutter/material.dart';

class AnimatedOpacityContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  const AnimatedOpacityContainer(
      {required this.child,
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.linear,
      this.onEnd});

  @override
  State<AnimatedOpacityContainer> createState() =>
      _AnimatedOpacityContainerState();
}

class _AnimatedOpacityContainerState extends State<AnimatedOpacityContainer> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _opacity = 1;
    });

    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      curve: widget.curve,
      onEnd: widget.onEnd,
      child: widget.child,
    );
  }
}
