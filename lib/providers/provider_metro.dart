import 'package:flutter/material.dart';
import 'package:metro/classes/constants.dart';
import 'package:metro/models/track.dart';

class MetroProvider with ChangeNotifier {

  bool _loading = false;
  bool _running = false;
  bool _tick = false;
  bool _fixedTickPeriod = false;
  String _backgroundColor = Constants.BACKGROUND_COLORS.first['key'];
  List<Track> _playlistItems = [];
  int _currentTrackIndex = 0;
  int _tempo = 100;
  bool _tempoChanged = false;
  bool _contentVisible = true;
  bool _autoHideContent = false;

  int get tempo {
    final track = getCurrentTrack();
    return (track != null && !_tempoChanged) ? track.tempo! : _tempo;
  }
  set tempo(int value) {
    final track = getCurrentTrack();
    if (track != null) _tempoChanged = true;
    _tempo = value;
    notifyListeners();
  }

  bool get tempoChanged => _tempoChanged;
  set tempoChanged(bool value) {
    _tempoChanged = value;
    notifyListeners();
  }

  bool get fixedTickPeriod => _fixedTickPeriod;
  set fixedTickPeriod(bool value) {
    _fixedTickPeriod = value;
    notifyListeners();
  }

  bool get tick => _tick;
  set tick(bool value) {
    _tick = value;
    notifyListeners();
  }

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get running => _running;
  set running(bool value) {
    _running = value;
    notifyListeners();
  }

  int get currentTrackIndex => _currentTrackIndex;
  set currentTrackIndex(int value) {
    _tempoChanged = false;
    _currentTrackIndex = value;
    notifyListeners();
  }

  Track? getCurrentTrack() {
    if (playlistItems.isEmpty) return null;
    return playlistItems[currentTrackIndex];
  }

  String get backgroundColor => _backgroundColor;
  set backgroundColor(String value) {
    _backgroundColor = value;
    notifyListeners();
  }

  List<Track> get playlistItems => _playlistItems;
  set playlistItems(List<Track>? value) {
    _playlistItems = value ?? [];
    notifyListeners();
  }

  Color getColor() {
    final item = Constants.BACKGROUND_COLORS.firstWhere((element) => element['key'] == _backgroundColor);
    return item['color'] as Color;
  }

  bool get contentVisible => _contentVisible;
  set contentVisible(bool value) {
    _contentVisible = value;
    notifyListeners();
  }

  bool get autoHideContent => _autoHideContent;
  set autoHideContent(bool value) {
    _autoHideContent = value;
    notifyListeners();
  }

  void reset() {
    _loading = false;
    _running = false;
    _tick = true;
    _tempo = 100;
    _fixedTickPeriod = false;
    _backgroundColor = Constants.BACKGROUND_COLORS.first['key'];
    _playlistItems = [];
    _currentTrackIndex = 0;
    _tempoChanged = false;
    _contentVisible = true;
    notifyListeners();
  }
}