// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> getDatabase() async {
  String caminhoDatabase = join(await getDatabasesPath(), 'rooms.db');
  return openDatabase(
    caminhoDatabase,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE rooms(id TEXT PRIMARY KEY, name TEXT, time TEXT, distance TEXT, date TEXT)",
      );
    },
  );
}
