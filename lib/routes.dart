import 'package:flutter/cupertino.dart';
import 'package:metro/pages/page_bootstrap.dart';
import 'package:metro/pages/page_home.dart';
import 'package:metro/pages/page_track.dart';
import 'package:metro/pages/page_playlist.dart';
import 'package:metro/pages/page_settings.dart';

class Routes {

  static const String ROUTE_BOOTSTRAP = "/";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_SETTINGS = "/settings";
  static const String ROUTE_PLAYLIST = "/playlist";
  static const String ROUTE_NEW_TRACK = "/newTrack";

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case ROUTE_BOOTSTRAP:
        return CupertinoPageRoute(builder: (_) => const BootstrapPage());
      case ROUTE_HOME:
        return CupertinoPageRoute(builder: (_) => const HomePage());
      case ROUTE_SETTINGS:
        return CupertinoPageRoute(builder: (_) => const SettingsPage());
      case ROUTE_PLAYLIST:
        return CupertinoPageRoute(builder: (_) => const PlaylistPage());
      case ROUTE_NEW_TRACK:
        return CupertinoPageRoute(builder: (_) => const TrackPage());
      default:
        return CupertinoPageRoute(builder: (_) => const BootstrapPage());
    }
  }
}
