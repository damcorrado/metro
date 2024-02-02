import 'package:flutter/material.dart';
import 'package:metro/models/track.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/routes.dart';
import 'package:metro/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackBarWidget extends StatefulWidget {

  const TrackBarWidget({super.key });

  @override
  State<TrackBarWidget> createState() => _TrackBarWidgetState();
}

class _TrackBarWidgetState extends State<TrackBarWidget> {

  late SharedPreferences prefs;
  late MetroProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);
    final items = provider.playlistItems;

    /// EMPTY PLAYLIST WIDGET
    if (items.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.orange,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No playlist",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        "Tap here to configure your playlist",
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _goToPlaylist,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      );
    } else {

      /// PLAYLIST NAVIGATOR
      // list is never empty; track is never null
      final Track currentTrack = provider.getCurrentTrack()!;
      return SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 2,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// PREV BUTTON
                Opacity(
                  opacity: _prevButtonVisible(),
                  child: IconButton(
                    onPressed: _prevTrack,
                    icon: const Icon(Icons.fast_rewind),
                  ),
                ),

                /// CENTER TITLE + BPM
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(ThemeConstants.borderRadius),
                    ),
                    onTap: _goToPlaylist,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            '${currentTrack.title}',
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${currentTrack.tempo} bpm',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// NEXT BUTTON
                Opacity(
                  opacity: _nextButtonVisible(),
                  child: IconButton(
                    onPressed: _nextTrack,
                    icon: const Icon(Icons.fast_forward),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  double _prevButtonVisible() {
    return (provider.currentTrackIndex) > 0 ? 1 : 0;
  }

  double _nextButtonVisible() {
    return (provider.currentTrackIndex < provider.playlistItems.length - 1) ? 1 : 0;
  }

  void _goToPlaylist() {
    Navigator.of(context).pushNamed(Routes.ROUTE_PLAYLIST);
  }

  void _prevTrack() {
    if (provider.currentTrackIndex > 0) provider.currentTrackIndex--;
  }

  void _nextTrack() {
    if (provider.currentTrackIndex < provider.playlistItems.length - 1) provider.currentTrackIndex++;
  }
}
