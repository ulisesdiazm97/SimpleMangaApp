import 'package:flutter/material.dart';
import 'package:simple_manga_app/screens/details_screen.dart';
import 'package:simple_manga_app/screens/home_screen.dart';
import 'package:simple_manga_app/screens/simple_reader_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Manga App',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(),
        // 'simple_reader': (_) => SimpleReaderScreen()
      },
    );
  }
}
