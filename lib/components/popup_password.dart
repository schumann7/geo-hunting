import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';
import '../screens/teste.dart';

class PasswordPopup extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onEnter;
  final TextEditingController controller;
  final double? roomLat;
  final double? roomLon;
  final String? senha;
  final String? roomClue;
  final String roomName;
  final String roomId;

  const PasswordPopup({
    super.key,
    this.roomLat,
    this.roomLon,
    required this.onClose,
    required this.onEnter,
    required this.controller,
    required this.roomClue,
    required this.roomName,
    required this.roomId,
    this.senha,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Digite a senha da sala'),
      content: TextField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(labelText: 'Senha'),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Sair",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            if (controller.text.trim() == senha!.toString().trim()) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TesteMapPage(
                        roomLat: roomLat,
                        roomLon: roomLon,
                        roomClue: roomClue,
                        roomName: roomName,
                        roomId: roomId,
                      ),
                ),
              );
            }
          },
          child: Text(
            "Entrar",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
