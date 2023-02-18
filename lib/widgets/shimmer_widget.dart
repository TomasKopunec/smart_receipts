import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  const ShimmerWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1200),
      baseColor: const Color.fromRGBO(210, 210, 210, 1),
      highlightColor: const Color.fromRGBO(140, 140, 140, 0.6),
      child: child,
    );
  }
}
