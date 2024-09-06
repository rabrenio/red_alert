import 'package:flutter/material.dart';

class TimeContainer extends StatelessWidget {
  final double? width;
  final Widget child;

  const TimeContainer({
    super.key,
    this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}
