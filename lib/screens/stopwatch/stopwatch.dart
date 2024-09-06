import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:red_alert/screens/stopwatch/action_buttons.dart';
import 'package:red_alert/screens/stopwatch/dtos/lap.dart';
import 'package:red_alert/screens/stopwatch/services/stopwatch_service.dart';
import 'package:red_alert/screens/stopwatch/tasks/stopwatch_task_handler.dart';
import 'package:red_alert/screens/stopwatch/laps.dart';
import 'package:red_alert/screens/stopwatch/timer_counter.dart';
import 'package:red_alert/screens/stopwatch/utils.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(StopwatchTaskHandler());
}

class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({super.key});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget>
    with WidgetsBindingObserver {
  List<Lap> _laps = [];
  int _elapsedMilliseconds = 0;

  Timer? _timer;
  StopwatchService? _stopwatchService;

  void handleStart() {
    _stopwatchService = StopwatchService()..start();

    if (_timer != null) return;

    const duration = Duration(milliseconds: 100);
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        _elapsedMilliseconds = _stopwatchService!.elapsedMilliseconds;
      });
    });
  }

  void handleStop() {
    _stopwatchService!.stop();
  }

  void handleLap() {
    final prevLap = _laps.lastOrNull;
    final currentMilliseconds = _stopwatchService!.elapsedMilliseconds;

    setState(() {
      _laps.add(
        Lap(
          elapsedMilliseconds: prevLap == null
              ? currentMilliseconds
              : currentMilliseconds - prevLap.elapsedMilliseconds,
          overallElapsedMilliseconds: currentMilliseconds,
        ),
      );
    });
  }

  void handleReset() {
    setState(() {
      _elapsedMilliseconds = 0;
      _laps = [];
    });

    _stopwatchService!.reset();

    _timer!.cancel();
    _timer = null;
  }

  Future<void> _requestAndroidNotificationPermissions() async {}

  Future<void> _initBackgroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'red_alert',
        channelName: 'red_alert',
        channelDescription:
            'This notification appears when the foreground service is running for stopwatch feature.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _showStopwatchNotification() async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.restartService();
    } else {
      final (minutes, seconds, _) = extractTime(_elapsedMilliseconds);
      await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Stopwatch',
        notificationText: getReadableTime([minutes, seconds]),
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        callback: startCallback,
      );

      final NotificationHandlerData data = {
        'elapsedMilliseconds': _elapsedMilliseconds,
        'isRunning': _stopwatchService!.isRunning,
      };
      FlutterForegroundTask.sendDataToTask(data);
    }
  }

  void _hideStopwatchNotification() {
    FlutterForegroundTask.stopService();
  }

  @override
  void initState() {
    // notification is only enabled for android
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
      _requestAndroidNotificationPermissions();
      _initBackgroundTask();
    }

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!Platform.isAndroid) return;

    if (state == AppLifecycleState.paused) {
      _showStopwatchNotification();
    } else if (state == AppLifecycleState.resumed) {
      _hideStopwatchNotification();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();

    if (Platform.isAndroid) {
      _hideStopwatchNotification();
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTimerOn = _elapsedMilliseconds > 0;

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              AnimatedSize(
                curve: Curves.easeInOutCubic,
                duration: const Duration(
                  milliseconds: 300,
                ),
                child: SizedBox(
                  height: _laps.isEmpty ? 150 : 50,
                ),
              ),
              DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 35,
                ),
                child: TimerCounter(
                  time: _elapsedMilliseconds,
                  cellWidth: 45,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Expanded(
                child: Laps(_laps),
              ),
            ],
          ),
        ),
        ActionButtons(
          isTimerOn: isTimerOn,
          isTimerRunning: _stopwatchService?.isRunning ?? false,
          onStart: handleStart,
          onStop: handleStop,
          onLap: handleLap,
          onReset: handleReset,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
