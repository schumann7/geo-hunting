import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';
import 'package:geo_hunting/screens/teste.dart';
import 'package:latlong2/latlong.dart';

import '../logic/create_rooms.dart';

class GameCreatePage extends StatefulWidget {
  const GameCreatePage({super.key});

  @override
  State<GameCreatePage> createState() => _GameCreatePageState();
}

class _GameCreatePageState extends State<GameCreatePage> {
  final TextEditingController _controllerRoomName = TextEditingController();

  final TextEditingController _controllerRoomPassword = TextEditingController();

  bool _isPrivate = false;
  LatLng coordenates = LatLng(-27.202456, -52.083215);
  bool create = true;

  @override
  Widget build(BuildContext context) {
    createRoom();
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
              ],
            ),
            _isPrivate
                ? TextSelectionTheme(
                  data: TextSelectionThemeData(
                    selectionColor: green.withOpacity(0.2),
                    cursorColor: Colors.black,
                    selectionHandleColor: green,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),
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
            SizedBox(
              width: 100,
              height: 270,
              child: Scaffold(
                body: TesteMapPage(
                  onMapTap: (LatLng latLng) {
                    setState(() {
                      coordenates = latLng;
                    });
                  },
                  create: true,
                ),
                extendBodyBehindAppBar: true,
                appBar: AppBar(
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
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
