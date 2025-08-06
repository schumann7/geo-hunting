import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

// Importando o componente de sala do jogo
import '../components/game_room.dart';

// Importando a lógica de pegar rooms
import '../logic/find_rooms.dart';

class GameEnterPage extends StatelessWidget {
  const GameEnterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: FutureBuilder(
            initialData: [],
            future: findRooms(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  debugPrint("Conexão não estabelecida");
                case ConnectionState.done:
                  List<dynamic> rooms = snapshot.data as List<dynamic>;
                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return Room(
                        roomName: rooms[index]['nomedasala'],
                        roomId: rooms[index]['id'],
                        roomLat: rooms[index]['latitude'],
                        roomLon: rooms[index]['longitude'],
                      );
                    },
                  );
              }
              return Text("a");
            },
          ),
        ),
      ),
    );
  }
}
