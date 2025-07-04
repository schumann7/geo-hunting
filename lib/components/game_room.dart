import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';

class Room extends StatelessWidget {
  final String roomName;
  final int roomId;

  const Room({super.key, required this.roomName, required this.roomId});

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
            onPressed: () {},
            icon: Icon(Icons.arrow_forward),
          ),
        ),
      ),
    );
  }
}
