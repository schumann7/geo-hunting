import 'package:flutter/material.dart';
import 'package:geo_hunting/main.dart';
import 'package:geo_hunting/screens/teste.dart';

class Room extends StatelessWidget {
  final String roomName;
  final int roomId;

  const Room({super.key, required this.roomName, required this.roomId});

  final bool quente = false;

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
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    leading: SizedBox(),
                    actions: [
                      Container(decoration: BoxDecoration(color: green, borderRadius: BorderRadius.all(Radius.circular(10))),child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.exit_to_app), color: Colors.white, iconSize: 35,),)
                    ],
                    title: Container(width: 200, height: 60, decoration: BoxDecoration(color: background), child: Row(
                      children: [
                        SizedBox(width: 50,),
                        Text("Sinal: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                        Text(quente? "Quente": "Frio", style: TextStyle(color: quente? Colors.red : Colors.blue, fontSize: 20, fontWeight: FontWeight.bold,),)
                      ],
                    ),),
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  body: TesteMapPage(),
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
