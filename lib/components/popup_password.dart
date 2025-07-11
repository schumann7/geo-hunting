import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

class PasswordPopup extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onEnter;
  final TextEditingController controller;

  const PasswordPopup({
    Key? key,
    required this.onClose,
    required this.onEnter,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Digite a senha da sala'),
      content: TextField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Senha',
        ),
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
                  onPressed: (){},
                  child: Text("Sair", style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
        ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: (){},
                  child: Text("Entrar", style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
      ],
    );
  }
}