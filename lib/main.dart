import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:point_system/screens/tab_screen.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: Colors.blueGrey, brightness: Brightness.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //debugPaintEnabled = false; // Disable debug paint for production
  runApp(ProviderScope(
  
    child: MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: kColorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home: TabScreen()),
  ));
}
