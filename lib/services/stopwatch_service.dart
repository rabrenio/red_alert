class StopwatchService {
  final Stopwatch _stopwatch = Stopwatch();
  Duration _initialDuration;

  StopwatchService({Duration initialDuration = Duration.zero})
      : _initialDuration = initialDuration;

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
  }

  void stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    }
  }

  void reset() {
    _stopwatch.reset();
    _initialDuration = Duration.zero;
  }

  int get elapsedMilliseconds =>
      _stopwatch.elapsedMilliseconds + _initialDuration.inMilliseconds;
  bool get isRunning => _stopwatch.isRunning;
}
