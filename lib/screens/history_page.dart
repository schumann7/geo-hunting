import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

//db
import 'package:geo_hunting/dao/salas_dao.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/salamodel.dart';

void main() {}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final newRoom = RoomHistory(
    id: "ID",
    name: "Teste",
    distance: "100",
    time: "10",
  );

  @override
  /*Future<void> _insertNewRoom() async {
    await insertRoom(newRoom);
  }*/
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: FutureBuilder<List<Map<dynamic, dynamic>>>(
            initialData: const [],
            future: findAll(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  debugPrint("Conexão não estabelecida");
                case ConnectionState.done:
                  List<Map> rooms = snapshot.data!;

                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 20),
                        color: background,
                        child: ListTileTheme(
                          iconColor: green,
                          child: ListTile(
                            title: Text(
                              rooms[index]['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text("ID: ${rooms[index]['id']}"),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Distância Percorrida: ${rooms[index]['distance']} m",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Tempo de Jogo: ${rooms[index]['time']}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
              }
              return Text("Erro desconhecido");
            },
          ),
        ),
      ),
    );
  }
}
