import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metro/classes/database_manager.dart';
import 'package:metro/classes/metro.utils.dart';
import 'package:metro/models/track.dart';
import 'package:metro/pages/page_track.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/theme/theme.dart';
import 'package:metro/widgets/playlist_item.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late MetroProvider provider;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "PLAYLIST",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: _close,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          if (provider.playlistItems.isNotEmpty) ...[
            IconButton(
              onPressed: _clearPlaylist,
              icon: const Icon(Icons.delete_outline_outlined),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.playlistItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/ic_note.svg', height: 100),
            const SizedBox(height: 50),
            Text(
              "Nothing here!",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _addTrack,
              child: const Text("Add new track"),
            ),
          ],
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ReorderableListView(
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) newIndex -= 1;
              final Track item = provider.playlistItems.removeAt(oldIndex);
              provider.playlistItems.insert(newIndex, item);
              _sortList();
            });
          },
          proxyDecorator: _proxyDecorator,
          children: [
            for (int i = 0; i < provider.playlistItems.length; i++) ...[
              PlaylistItem(
                context,
                index: i,
                track: provider.playlistItems[i],
                key: Key('playlist-item-$i'),
                onPlayCallback: (index) {
                  _onItemPlayCallback(index);
                },
                onOptionsCallback: (index) {
                  _onItemOptionsCallback(index);
                },
              ),
            ]
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 200,
            child: FilledButton(
              onPressed: _addTrack,
              child: const Text("Add new"),
            ),
          ),
        ),
      ],
    );
  }

  /// Decoration of listview item when drag start
  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.borderRadius)),
          elevation: elevation,
          color: Theme.of(context).colorScheme.primary,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Add new track
  void _addTrack() {
    Widget content = TrackPage(
      onInsert: () {
        MetroUtils.showSnackbar(context, "Saved!");
        _refreshList();
      },
    );
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    ).then((value) {
      _refreshList();
    });
  }

  /// Edit an existing track
  void _editTrack(Track track) {
    Widget content = TrackPage(
      track: track,
      onInsert: () {
        MetroUtils.showSnackbar(context, "Saved!");
        _refreshList();
      },
    );
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return content;
      },
    ).then((value) {
      _refreshList();
    });
  }

  /// Navigate back to home page
  void _close() {
    MetroUtils.handleContentVisibility(context);
    Navigator.of(context).pop();
  }

  /// Fetch all tracks from database
  Future<void> _refreshList() async {
    setState(() {
      _loading = true;
    });

    provider.playlistItems = await DatabaseManager().playlistItems();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loading = false;
    });
  }

  /// Delete all tracks from playlist
  /// Reset database table
  void _clearPlaylist() {
    MetroUtils.showOptionDialog(
        context: context,
        text: "Do you want to delete all track from this playlist?",
        positiveActionText: "Yes, delete",
        negativeActionText: "Cancel",
        positiveActionCallback: () async {
          await DatabaseManager().resetDB();
          provider.playlistItems = [];
          provider.currentTrackIndex = 0;
          provider.running = false;
          Navigator.of(context).pop();
        });
  }

  /// Delete single track
  void _deleteTrack(Track track) {
    MetroUtils.showOptionDialog(
        context: context,
        text: "Are you sure you want to delete ${track.title} from playlist?",
        positiveActionText: "Yes, delete",
        negativeActionText: "Cancel",
        positiveActionCallback: () async {
          Navigator.of(context).pop();
          setState(() {
            _loading = true;
          });
          await DatabaseManager().delete(id: track.id!);
          provider.currentTrackIndex = 0;
          _refreshList();
        });
  }

  /// Sort current list in provider
  /// Update all tracks in database with new order
  void _sortList() async {
    for (var i = 0; i < provider.playlistItems.length; i++) {
      Track track = provider.playlistItems[i];
      track.sort = i;
      await DatabaseManager().update(track);
    }
  }

  /// Set current track index in provider and navigate back to home page
  void _onItemPlayCallback(int index) {
    provider.currentTrackIndex = index;
    Navigator.of(context).pop();
  }

  /// show a modal BottomSheet with options: [edit, delete]
  void _onItemOptionsCallback(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: Text('Edit', style: Theme.of(context).textTheme.bodyLarge,),
                onTap: () {
                  Navigator.pop(context);
                  final track = provider.playlistItems[index];
                  _editTrack(track);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text('Delete', style: Theme.of(context).textTheme.bodyLarge,),
                onTap: () {
                  Navigator.pop(context);
                  final track = provider.playlistItems[index];
                  _deleteTrack(track);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
