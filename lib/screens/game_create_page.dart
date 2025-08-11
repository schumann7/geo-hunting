import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../main.dart'; // ajuste conforme seu projeto
import '../screens/teste.dart'; // seu mapa
// Se green e background estão no main.dart, mantenha este import

// Pacote para fazer cards popup
import 'package:flutter_popup_card/flutter_popup_card.dart';

class GameCreatePage extends StatefulWidget {
  const GameCreatePage({super.key});

  @override
  State<GameCreatePage> createState() => _GameCreatePageState();
}

class _GameCreatePageState extends State<GameCreatePage> {
  final TextEditingController _controllerRoomName = TextEditingController();
  final TextEditingController _controllerRoomPassword = TextEditingController();
  final TextEditingController _controllerRoomClue = TextEditingController();

  bool _isPrivate = false;
  bool _hasClue = false;
  LatLng coordenates = LatLng(-27.202456, -52.083215);

  Future<void> createRoom() async {
    final url = Uri.parse(
      'http://ec2-15-228-201-167.sa-east-1.compute.amazonaws.com/create_room',
    );

    // Monta o mapa sem o campo senha inicialmente
    final Map<String, dynamic> dados = {
      "nomedasala": _controllerRoomName.text.trim(),
      "latitude": coordenates.latitude.toString(),
      "longitude": coordenates.longitude.toString(),
      "privada": _isPrivate,
      "dica": _controllerRoomClue.text.trim(),
    };

    print(dados);

    // Só adiciona o campo senha se for privada
    if (_isPrivate) {
      dados["senha"] = _controllerRoomPassword.text;
    }

    print("Enviando dados: $dados");

    try {
      final resposta = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(dados),
      );

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        print("Sala criada com sucesso!");
        print("Resposta: ${resposta.body}");
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Sala criada com sucesso!")));

        _controllerRoomName.clear();
        _controllerRoomPassword.clear();
        _controllerRoomClue.clear();
        setState(() {
          _isPrivate = false;
          _hasClue = false;
        });
      } else {
        print("Erro ao criar sala: ${resposta.statusCode}");
        print("Mensagem: ${resposta.body}");
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar sala: ${resposta.body}")),
        );
      }
    } catch (e) {
      print("Erro de conexão: $e");
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro de conexão com o servidor.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20.0),
          children: [
            TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: green.withOpacity(0.2),
                cursorColor: Colors.black,
                selectionHandleColor: green,
              ),
              child: TextField(
                controller: _controllerRoomName,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  label: Text("Nome da Sala"),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: green,
                  hoverColor: green,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  "Sala privada:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Checkbox(
                  activeColor: green,
                  checkColor: background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  value: _isPrivate,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value ?? false;
                    });
                  },
                ),
                SizedBox(width: 10),
                Flexible(
                  child:
                      _isPrivate
                          ? TextSelectionTheme(
                            data: TextSelectionThemeData(
                              selectionColor: green.withOpacity(0.2),
                              cursorColor: Colors.black,
                              selectionHandleColor: green,
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  obscureText: true,
                                  controller: _controllerRoomPassword,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    floatingLabelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    label: Text("Senha da Sala"),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusColor: green,
                                    hoverColor: green,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : SizedBox(height: 56),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: 100,
              height: 270,
              child: Scaffold(
                body: TesteMapPage(
                  getLocation: () async {
                    Position position = await Geolocator.getCurrentPosition();
                    setState(() {
                      coordenates = LatLng(
                        position.latitude,
                        position.longitude,
                      );
                    });
                  },
                  onMapTap: (LatLng latLng) {
                    setState(() {
                      coordenates = latLng;
                    });
                  },
                  create: true,
                ),
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                    "${(coordenates.latitude * 100000).round() / 100000}, ${(coordenates.longitude * 100000).round() / 100000}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  leading: SizedBox(width: 0),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Dica:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Checkbox(
                  activeColor: green,
                  checkColor: background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  value: _hasClue,
                  onChanged: (value) {
                    setState(() {
                      _hasClue = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          showPopupCard(
                            context: context,
                            builder: (context) {
                              return PopupCard(
                                elevation: 10,
                                color: white,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),

                                  child: SizedBox(
                                    width: 220,
                                    height: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Como funcionam as dicas?",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Este jogo possui uma função que exibe uma dica ao usuário sobre onde encontrar o tesouro quando um botão é pressionado. Essa função é opcinal, se desabilitada o botão de dica não será exibido durante o jogo.",
                                        ),
                                        SizedBox(height: 20),

                                        ElevatedButton(
                                          child: Text(
                                            "Fechar",
                                            style: TextStyle(
                                              color: green,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.question_mark_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _hasClue
                ? TextSelectionTheme(
                  data: TextSelectionThemeData(
                    selectionColor: green.withOpacity(0.2),
                    cursorColor: Colors.black,
                    selectionHandleColor: green,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controllerRoomClue,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          label: Text("Dica do Tesouro"),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusColor: green,
                          hoverColor: green,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
                : Text(""),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (_controllerRoomName.text != "") {
                  if (_isPrivate == true &&
                      _controllerRoomPassword.text == "") {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Insira uma senha válida.")),
                    );
                  } else if (_hasClue == true &&
                      _controllerRoomClue.text == "") {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Insira uma dica válida.")),
                    );
                  } else {
                    createRoom();
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("A sala deve ter um nome.")),
                  );
                }
              },
              child: Text(
                "Criar sala",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
