// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

class Constants {

  // Duration in seconds
  static const int AUTO_HIDE_CONTENT_TIMEOUT = 5;

  static const int FIXED_TICK_PERIOD = 50;
  static const int TEMPO_MIN_VALUE = 40;
  static const int TEMPO_MAX_VALUE = 300;

  static const String DATABASE_NAME = "metro.db";

  static const String PREFS_BACKGROUND_COLOR = "PREFS_BACKGROUND_COLOR";
  static const String PREFS_FIXED_TICK_PERIOD = "PREFS_FIXED_TICK_PERIOD";
  static const String PREFS_AUTO_HIDE_CONTENT = "PREFS_AUTO_HIDE_CONTENT";

  static const List<Map<String, dynamic>> BACKGROUND_COLORS = [
    {"key": "white", "color": Color(0xFFCCCCCC)},
    {"key": "red", "color": Color(0xFFF44335)},
    {"key": "teal", "color": Color(0xFF019688)},
    {"key": "orange", "color": Color(0xFFFF9800)},
    {"key": "yellow", "color": Color(0xFFFFEB3C)}
  ];

}