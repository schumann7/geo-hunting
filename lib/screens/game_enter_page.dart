import 'package:flutter/material.dart';

class GameEnterPage extends StatelessWidget {
  const GameEnterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF9FA6A1)),
      body: Center(
        child: Text(
          'Tela de Entrar em uma Sala',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}