import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

class NoDataFoundWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double height;

  const NoDataFoundWidget({
    required this.height,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  State<NoDataFoundWidget> createState() => _NoDataFoundWidgetState();
}

class _NoDataFoundWidgetState extends State<NoDataFoundWidget> {
  final Duration animDuration = const Duration(milliseconds: 1250);
  final Curve animCurve = Curves.fastLinearToSlowEaseIn;

  double animParam = 0;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1)).then(
      (value) {
        if (mounted) {
          setState(() {
            animParam = 1;
          });
        }
      },
    );

    return AnimatedScale(
      scale: animParam,
      duration: animDuration,
      curve: animCurve,
      child: AnimatedOpacity(
        opacity: animParam,
        duration: animDuration,
        curve: animCurve,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
              child: SizedBox(
                  height: widget.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      title,
                      const SizedBox(height: 10),
                      subtext
                    ],
                  ))),
        ),
      ),
    );
  }

  Widget get title {
    return Center(
        child: Text(
      widget.title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: SizeHelper.getFontSize(context, size: FontSize.larger)),
    ));
  }

  Widget get subtext {
    return Center(
        child: Text(
      widget.subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: SizeHelper.getFontSize(context, size: FontSize.regular)),
    ));
  }

  Widget get icon {
    final height = widget.height * 0.7;
    return FittedBox(
      clipBehavior: Clip.none,
      fit: BoxFit.fitHeight,
      child: Icon(
        widget.icon,
        size: height,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
