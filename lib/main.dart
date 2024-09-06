import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_alert/screens/home/home.dart';
import 'package:red_alert/screens/stopwatch/stopwatch.dart';

void main() {
  FlutterForegroundTask.initCommunicationPort();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _currentIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const StopwatchWidget(),
  ];

  void _onTabPress(int nextIndex) {
    setState(() {
      _currentIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) => PlatformApp(
        title: 'Red Alert',
        home: PlatformScaffold(
          body: SafeArea(
            child: _screens[_currentIndex],
          ),
          bottomNavBar: PlatformNavBar(
            currentIndex: _currentIndex,
            itemChanged: _onTabPress,
            items: const [
              BottomNavigationBarItem(
                label: 'Alarm',
                icon: Icon(Icons.alarm),
              ),
              BottomNavigationBarItem(
                label: 'Stopwatch',
                icon: Icon(Icons.hourglass_bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
