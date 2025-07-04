import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/map.dart';

Color background = Color(0xFF9FA6A1);
Color green = Color(0xFF185C3C);
Color white = Color(0xFFD9D9D9);

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Hunting',
      theme: ThemeData(
        scaffoldBackgroundColor: background,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
