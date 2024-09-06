import 'package:flutter/material.dart';
import 'package:red_alert/screens/stopwatch/dtos/lap.dart';
import 'package:red_alert/screens/stopwatch/timer_counter.dart';

class _LapItem extends StatelessWidget {
  final Lap lap;
  final String lapNumber;

  const _LapItem({
    required this.lap,
    required this.lapNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(lapNumber),
            ),
            Expanded(
              child: TimerCounter(
                time: lap.elapsedMilliseconds,
              ),
            ),
            Expanded(
              child: TimerCounter(
                time: lap.overallElapsedMilliseconds,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class Laps extends StatelessWidget {
  final List<Lap> laps;

  const Laps(this.laps, {super.key});

  @override
  Widget build(BuildContext context) {
    if (laps.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedLapsByLatest = laps.reversed.toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontSize: 14,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('Lap'),
                ),
                Expanded(
                  child: Text('Lap times'),
                ),
                Expanded(
                  child: Text('Overall time'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _LapItem(
                          lap: sortedLapsByLatest[index],
                          lapNumber:
                              (sortedLapsByLatest.length - index).toString(),
                        );
                      },
                      childCount: laps.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
