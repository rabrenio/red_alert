import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

ButtonStyle _secondaryButtonStyle(BuildContext context) {
  return TextButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    foregroundColor: Theme.of(context).colorScheme.onSecondary,
  );
}

class ActionButtons extends StatelessWidget {
  final bool isTimerOn;
  final bool isTimerRunning;

  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onLap;
  final VoidCallback onReset;

  const ActionButtons({
    super.key,
    required this.isTimerOn,
    required this.isTimerRunning,
    required this.onLap,
    required this.onStart,
    required this.onStop,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: !isTimerOn || isTimerRunning
                  ? PlatformTextButton(
                      material: (_, __) => MaterialTextButtonData(
                        style: _secondaryButtonStyle(context),
                      ),
                      onPressed: isTimerOn ? onLap : null,
                      child: const Text('Lap'),
                    )
                  : PlatformTextButton(
                      material: (_, __) => MaterialTextButtonData(
                        style: _secondaryButtonStyle(context),
                      ),
                      onPressed: onReset,
                      child: const Text('Reset'),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: isTimerRunning
                  ? PlatformTextButton(
                      onPressed: onStop,
                      child: const Text('Stop'),
                      material: (_, __) => MaterialTextButtonData(
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                      ),
                    )
                  : PlatformTextButton(
                      material: (_, __) => MaterialTextButtonData(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextButtonData(
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      onPressed: onStart,
                      child: Text(isTimerOn ? 'Resume' : 'Start'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
