import 'package:flutter/widgets.dart';
import 'package:red_alert/screens/stopwatch/time_container.dart';

class TimeSeparator extends StatelessWidget {
  final double? width;

  const TimeSeparator({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return TimeContainer(
      width: width,
      child: const Text(
        ':',
        textAlign: TextAlign.center,
      ),
    );
  }
}
