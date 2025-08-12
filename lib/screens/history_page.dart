import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Text("A"),
        ),
      ),
    );
  }
}
