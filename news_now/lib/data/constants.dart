import 'package:flutter/material.dart';

class KConstants {
  static const String themeModekey = 'themeMode';
}

class KValue {
  static const String basicLayout = "BasicLayout";
  static const String cleanUI = "Clean UI";
  static const String fixBugs = "Fix Bugs";
  static const String keyConcepts = "Key Concepts";
}

class KTextStyle {
  static const TextStyle titleTealText = TextStyle(
    fontSize: 20.0,
    color: Colors.teal,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arial',
    letterSpacing: 1.2,
    fontStyle: FontStyle.italic,
  );
  static const TextStyle titleBlackText = TextStyle(
    fontSize: 20.0,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arial',
    letterSpacing: 1.2,
    fontStyle: FontStyle.italic,
  );
}
