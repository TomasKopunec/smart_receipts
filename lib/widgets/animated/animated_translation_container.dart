import 'package:flutter/material.dart';

class AnimatedTranslationContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;
  final Offset offset;

  const AnimatedTranslationContainer(
      {required this.child,
      required this.offset,
      this.duration = const Duration(milliseconds: 500),
      this.curve = Curves.linear,
      this.onEnd});

  @override
  State<AnimatedTranslationContainer> createState() =>
      _AnimatedOpacityContainerState();
}

class _AnimatedOpacityContainerState extends State<AnimatedTranslationContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() => widget.onEnd);

    final curvedAnimation =
        CurvedAnimation(parent: _controller, curve: widget.curve);

    _animation = Tween(begin: -250.0, end: 0.0).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Transform.translate(
      offset: Offset(0, _animation.value),
      child: widget.child,
    );
  }
}
