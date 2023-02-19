import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Function onPressed;
  final ButtonStyle? style;
  final Widget? child;

  const LoadingButton({
    super.key,
    required this.onPressed,
    this.style,
    this.child,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() => _isLoading = true);
        await widget.onPressed();
        setState(() => _isLoading = false);
      },
      style: widget.style,
      child: _isLoading
          ? Transform.scale(
              scale: 0.675,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : widget.child,
    );
  }
}
