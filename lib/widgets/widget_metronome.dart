import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/classes/metro.utils.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/theme/theme.dart';
import 'package:provider/provider.dart';

class MetronomeWidget extends StatefulWidget {
  const MetronomeWidget({super.key});

  @override
  State<MetronomeWidget> createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget> {
  late MetroProvider provider;
  late Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopMetronome();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _decrease(1);
                },
                child: const Text("-1"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _decrease(5);
                },
                child: const Text("-5"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _decrease(10);
                },
                child: const Text("-10"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Stack(
              children: [
                /// TEMPO
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("TEMPO", style: Theme.of(context).textTheme.labelSmall),
                      Text(provider.tempo.toString(), style: Theme.of(context).textTheme.displayLarge),
                      if (provider.running) ...[
                        Icon(
                          Icons.pause_rounded,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ] else ...[
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 30,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ],
                    ],
                  ),
                ),

                /// CIRCLE
                SizedBox(
                  height: 200,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                    onTap: () {
                      provider.running ? _stopMetronome() : _startMetronome();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onBackground,
                          width: 2.0, // Set the border width
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _increase(1);
                },
                child: const Text("+1"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _increase(5);
                },
                child: const Text("+5"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _increase(10);
                },
                child: const Text("+10"),
              ),
            ],
          ),

          // if tempo changes show this card in order to reset
          Opacity(
            opacity: (provider.tempoChanged) ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Card(
                color: Colors.orange,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.borderRadius)),
                  onTap: _resetTempo,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Bpm was changed, tap to reset",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Decrease BPM value
  _decrease(int value) {
    provider.tempo = max(Constants.TEMPO_MIN_VALUE, provider.tempo - value);
    setState(() {});
  }

  /// Increase BPM value
  _increase(int value) {
    provider.tempo = min(Constants.TEMPO_MAX_VALUE, provider.tempo + value);
    setState(() {});
  }

  /// Start metronome periodic timer
  /// Every cycle toggle the background color
  void _startMetronome() {
    _toggleBackgroundColor(null);
    provider.running = true;
    final int milliseconds = (60 * 1000 / provider.tempo).round();
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), _toggleBackgroundColor);

    MetroUtils.handleContentVisibility(context);
  }

  /// Stop the metronome timer
  void _stopMetronome() {
    _timer?.cancel();
    provider.running = false;
  }

  void _toggleBackgroundColor(Timer? _) {
    provider.tick = true;
    final interval = provider.fixedTickPeriod ? Constants.FIXED_TICK_PERIOD : ((60 * 1000 / provider.tempo) / 2).round();
    Future.delayed(Duration(milliseconds: interval)).then((_) {
      provider.tick = false;
    });
  }

  /// If tempo was changed and exists a track in playlist
  /// Reset the bpm tempo inside the provider to track's default bpm
  void _resetTempo() {
    final track = provider.getCurrentTrack();
    if (track != null) {
      provider.tempo = track.tempo!;
      provider.tempoChanged = false;
    }
  }
}
