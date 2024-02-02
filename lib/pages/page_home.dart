import 'package:flutter/material.dart';
import 'package:metro/classes/metro.utils.dart';
import 'package:metro/pages/page_settings.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/widgets/widget_metronome.dart';
import 'package:metro/widgets/widget_trackbar.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late MetroProvider provider;

  @override
  void initState() {
    super.initState();
    // Enable wakelock to prevent the screen from turning off
    Wakelock.enable();
  }

  @override
  void dispose() {
    // Disable wakelock when the widget is disposed
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);

    bool tick = provider.tick;
    Color bgColor = tick ? provider.getColor() : Theme.of(context).colorScheme.background;
    return GestureDetector(
      onTap: () { MetroUtils.handleContentVisibility(context); },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            Visibility(
              visible: provider.contentVisible,
              child: IconButton(
                onPressed: _goToSettings,
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: AnimatedOpacity(
            opacity: provider.contentVisible ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: AbsorbPointer(
              absorbing: provider.contentVisible ? false : true,
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MetronomeWidget(),
                  TrackBarWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Show the settings page in a BottomSheet
  void _goToSettings() {
    Widget content = const SettingsPage();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return content;
      },
    ).then((value) {
      MetroUtils.handleContentVisibility(context);
    });
  }
}
