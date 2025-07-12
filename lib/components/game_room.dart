import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

import 'package:geo_hunting/components/popup_password.dart';
import 'package:geo_hunting/screens/teste.dart'; // Adicione este import

class Room extends StatelessWidget {
  final String roomName;
  final int roomId;

  const Room({super.key, required this.roomName, required this.roomId});

  final bool quente = false;

  void _showPasswordPopup(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return PasswordPopup(
          controller: _passwordController,
          onClose: () {
            Navigator.of(context).pop();
          },
          onEnter: () {
            // Aqui você pode tratar a senha futuramente
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TesteMapPage()),
            );
            // Se quiser navegar para a sala após a senha, mova o Navigator.push para cá
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      color: white,
      child: ListTileTheme(
        iconColor: green,
        child: ListTile(
          leading: Text(
            roomName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              _showPasswordPopup(context);
            },
            icon: Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
