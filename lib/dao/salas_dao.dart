import 'package:geo_hunting/database/db.dart';
import 'package:geo_hunting/model/salamodel.dart';
import 'package:sqflite/sqflite.dart';

Future<int> insertRoom(RoomHistory room) async {
  final Database db = await getDatabase();
  return db.insert(
    "rooms",
    room.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

//findAll()
Future<List<Map>> findAll() async {
  final Database db = await getDatabase();
  return db.query("rooms");
}

//DeleteByID
Future<int> deleteById(String id) async {
  final Database db = await getDatabase();
  return db.delete('rooms', where: 'id = ?', whereArgs: [id]);
}
