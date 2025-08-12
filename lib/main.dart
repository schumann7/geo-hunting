import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'dart:io';

Color background = Color(0xE5E5E5FF);
Color green = Color(0xFF185C3C);
Color white = Color.fromARGB(255, 229, 229, 255);

void main() {
  runApp(const MyApp());
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
