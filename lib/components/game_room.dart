import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';
import 'package:geo_hunting/components/popup_password.dart';
import 'package:geo_hunting/screens/teste.dart';

class Room extends StatelessWidget {
  final String roomName;
  final String roomId;
  final String roomLat;
  final String roomLon;
  final bool privada;
  final String? senha;
  final String? roomClue;

  const Room({
    super.key,
    required this.roomName,
    required this.roomId,
    required this.roomLat,
    required this.roomLon,
    required this.privada,
    required this.roomClue,
    this.senha,
  });

  final bool quente = false;

  void _showPasswordPopup(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return PasswordPopup(
          roomId: roomId,
          roomName: roomName,
          roomClue: roomClue,
          roomLat: double.parse(roomLat),
          roomLon: double.parse(roomLon),
          senha: senha,
          controller: passwordController,
          onClose: () {
            Navigator.of(context).pop();
          },
          onEnter: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      color: background,
      child: ListTileTheme(
        iconColor: green,
        child: ListTile(
          subtitle: Text(privada ? "Sala Privada" : "Sala Pública"),
          title: Text(
            roomName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: Text("ID \n $roomId", textAlign: TextAlign.center),
          trailing: IconButton(
            onPressed: () {
              privada
                  ? _showPasswordPopup(context)
                  : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TesteMapPage(
                            roomLat: double.parse(roomLat),
                            roomLon: double.parse(roomLon),
                            roomClue: roomClue,
                            roomName: roomName,
                            roomId: roomId,
                          ),
                    ),
                  );
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
