import 'package:flutter/material.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/classes/database_manager.dart';
import 'package:metro/models/track.dart';
import 'package:metro/providers/provider_metro.dart';
import 'package:metro/theme/theme.dart';
import 'package:provider/provider.dart';

class TrackPage extends StatefulWidget {
  final Track? track;
  final Function? onInsert;

  const TrackPage({super.key, this.track, this.onInsert});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final _formKey = GlobalKey<FormState>();
  late MetroProvider provider;

  bool _loading = false;
  String? _title;
  int? _tempo;
  String? _note;

  @override
  void initState() {
    if (widget.track != null) {
      _title = widget.track!.title;
      _tempo = widget.track!.tempo;
      _note = widget.track!.note;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MetroProvider>(context, listen: true);

    String title = widget.track != null ? "EDIT TRACK" : " ADD NEW TRACK";
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(ThemeConstants.borderRadius),
            topRight: Radius.circular(ThemeConstants.borderRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelLarge),
                  IconButton(
                    onPressed: _close,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: Column(
                children: [

                  // FORM CONTENT
                  _buildContent(),

                  const SizedBox(height: 80),
                  if (_loading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else ...[
                    SizedBox(
                      width: 200,
                      child: OutlinedButton(
                        onPressed: _save,
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Title'),
            initialValue: _title,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) {
              _title = value!;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Bpm'),
            initialValue: _tempo != null ? _tempo.toString() : '',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }

              int parsed = int.parse(value);
              if (parsed < Constants.TEMPO_MIN_VALUE || parsed > Constants.TEMPO_MAX_VALUE) {
                return 'Bpm must be between ${Constants.TEMPO_MIN_VALUE} and ${Constants.TEMPO_MAX_VALUE}';
              }

              return null;
            },
            onSaved: (value) {
              // Parse the value as an integer
              _tempo = int.parse(value!);
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Note'),
            initialValue: _note,
            maxLines: 3,
            onSaved: (value) {
              _note = value!;
            },
          ),
        ],
      ),
    );
  }

  /// Insert a new object or update an existing one if Track is passed in constructor
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _loading = true;
      });

      if (widget.track != null) {
        // UPDATE
        Track track = Track(id: widget.track!.id, title: _title, tempo: _tempo, note: _note, sort: widget.track!.sort);
        await DatabaseManager().update(track);
      } else {
        // INSERT
        int sortIndex = provider.playlistItems.length;
        Track track = Track(title: _title, tempo: _tempo, note: _note, sort: sortIndex);
        await DatabaseManager().insert(track);
      }

      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _loading = false;
      });

      if (widget.onInsert != null) widget.onInsert!();
      _close();
    }
  }

  void _close() {
    Navigator.of(context).pop();
  }
}
