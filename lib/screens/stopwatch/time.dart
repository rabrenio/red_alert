import 'package:flutter/widgets.dart';
import 'package:red_alert/screens/stopwatch/time_container.dart';
import 'package:red_alert/screens/stopwatch/utils.dart';

class Time extends StatelessWidget {
  final int time;
  final double? width;

  const Time({
    super.key,
    this.width,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return TimeContainer(
      width: width,
      child: Text(getStringTime(time)),
    );
  }
}
