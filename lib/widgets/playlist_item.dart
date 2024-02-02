import 'package:flutter/material.dart';
import 'package:metro/models/track.dart';

class PlaylistItem extends StatefulWidget {
  final BuildContext context;
  final int index;
  final Track track;
  final Function? onPlayCallback;
  final Function? onOptionsCallback;

  const PlaylistItem(this.context, {super.key, required this.index, required this.track, this.onPlayCallback, this.onOptionsCallback});

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.track.tempo.toString(),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'bpm',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 8, color: Theme.of(context).colorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.track.title}',
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.track.note != null && widget.track.note!.isNotEmpty) ...[
                    Text(
                      '${widget.track.note}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                widget.onPlayCallback != null ? widget.onPlayCallback!(widget.index) : null;
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            IconButton(
              onPressed: () {
                widget.onOptionsCallback != null ? widget.onOptionsCallback!(widget.index) : null;
              },
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
      ),
    );
  }
}