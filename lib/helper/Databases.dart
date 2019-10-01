import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/Strings.dart';

class Databases{
  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "12345dbhh.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $loginTable($idLoginColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nomeLoginColumn TEXT, $emailLoginColumn TEXT, $senhaLoginColumn TEXT);"
      );
      await db.execute(
          "CREATE TABLE $logadoTable ($idLogadoColumn INTEGER PRIMARY KEY AUTOINCREMENT,$login_idLogadoColumn INT);"
      );
      await db.execute(
          "CREATE TABLE $personTable($idPersonColumn INTEGER PRIMARY KEY, $nomePersonColumn TEXT, $telefonePersonColumn TEXT, $login_idPersonColumn INTEGER)"
      );
    });
  }
}