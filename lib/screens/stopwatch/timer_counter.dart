import 'package:flutter/widgets.dart';
import 'package:red_alert/screens/stopwatch/time.dart';
import 'package:red_alert/screens/stopwatch/time_separator.dart';
import 'package:red_alert/screens/stopwatch/utils.dart';

class TimerCounter extends StatelessWidget {
  final int time;
  final double? cellWidth;
  final MainAxisAlignment mainAxisAlignment;

  const TimerCounter({
    super.key,
    this.cellWidth,
    this.mainAxisAlignment = MainAxisAlignment.start,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final (minutes, seconds, milliseconds) = extractTime(time);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Time(time: minutes, width: cellWidth),
        TimeSeparator(width: cellWidth),
        Time(time: seconds, width: cellWidth),
        TimeSeparator(width: cellWidth),
        Time(time: milliseconds, width: cellWidth),
      ],
    );
  }
}
