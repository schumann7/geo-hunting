import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

// Importando o componente de sala do jogo
import '../components/game_room.dart';

class GameEnterPage extends StatelessWidget {
  const GameEnterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            Room(roomName: "Sala do Schumann", roomId: 1),
            Room(roomName: "Sala do Rômulo", roomId: 2),
          ],
        ),
      ),
    );
  }
}
