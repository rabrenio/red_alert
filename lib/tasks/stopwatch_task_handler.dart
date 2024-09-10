import 'dart:async';
import 'dart:developer';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:red_alert/services/stopwatch_service.dart';
import 'package:red_alert/screens/stopwatch/utils.dart';

typedef NotificationHandlerData = Map<String, dynamic>;

class StopwatchTaskHandler extends TaskHandler {
  Timer? _timer;
  StopwatchService? _stopwatchService;

  @override
  void onStart(DateTime timestamp) {
    log('starting StopwatchTaskHandler');
  }

  @override
  void onReceiveData(Object data) {
    if (_timer == null && data is NotificationHandlerData) {
      _updateStopWatchNotification(data);
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  void onDestroy(DateTime timestamp) {
    log('destroying StopwatchTaskHandler');
    _timer?.cancel();
  }

  void _updateStopWatchNotification(NotificationHandlerData data) {
    final bool isRunning = data['isRunning'];

    if (!isRunning) {
      return;
    }

    final int elapsedMilliseconds =
        int.parse(data['elapsedMilliseconds'].toString());

    _stopwatchService = StopwatchService(
      initialDuration: Duration(milliseconds: elapsedMilliseconds),
    )..start();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      log('receiving data and ticking');

      final (minutes, seconds, _) =
          extractTime(_stopwatchService!.elapsedMilliseconds);
      FlutterForegroundTask.updateService(
        notificationText: getReadableTime([minutes, seconds]),
      );
    });
  }
}
