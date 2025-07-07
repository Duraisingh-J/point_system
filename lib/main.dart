import 'package:flutter/material.dart';
import 'package:point_system/screens/items_screen.dart';
import 'package:point_system/screens/tab_screen.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: Colors.grey, );

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
