import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

//db
import 'package:geo_hunting/dao/salas_dao.dart';

void main() {}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
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
                  List<Map<String, dynamic>> rooms =
                      (snapshot.data as List<Map<String, dynamic>>)
                                  .toString()
                                  .trim() ==
                              "[]".trim()
                          ? [{}]
                          : snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data.toString().trim() == "[]".trim()) {
                        return Text(
                          "Encontre tesouros para poder visualizar o histórico de suas partidas aqui.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        );
                      }
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
                                Text(rooms[index]['date']),
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
