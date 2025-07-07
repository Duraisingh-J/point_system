import 'package:flutter/material.dart';
import 'package:point_system/screens/tab_screen.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.light);

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: kColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: kColorScheme.primary,
        foregroundColor: Colors.white,
      ),
    ),
    home: TabScreen()));
}
