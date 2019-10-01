import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../utils/Strings.dart';
import '../helper/Databases.dart';

class PersonHelper {
  static final PersonHelper _instance = PersonHelper.internal();
  factory PersonHelper() => _instance;
  PersonHelper.internal();

  Databases databases = new Databases();

  Future<Person> savePerson(Person person,int login_id) async {
    Person person2 = person;
    Person novaPerson = Person();
    novaPerson.login_id = login_id;
    novaPerson.nome = person2.nome;
    novaPerson.telefone = person2.telefone;
    Database dbPerson = await databases.db;
    person.id = await dbPerson.insert(personTable, novaPerson.toMap());
    return person;
  }

  Future<Person> getPerson(int id) async {
    Database dbPerson = await databases.db;
    List<Map> maps = await dbPerson.query(personTable,
        columns: [idPersonColumn, nomePersonColumn, telefonePersonColumn],
        where: "$idPersonColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Person.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePerson(int id) async {
    Database dbPerson = await databases.db;
    return await dbPerson.delete(personTable, where: "$idPersonColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePerson(Person person,int login_id) async {
    Person person2 = person;
    Person novaPerson = Person();
    novaPerson.login_id = login_id;
    novaPerson.nome = person2.nome;
    novaPerson.telefone = person2.telefone;
    Database dbPerson = await databases.db;
    return await dbPerson.update(personTable,
        novaPerson.toMap(),
        where: "$idPersonColumn = ?",
        whereArgs: [person2.id]);
  }

  Future<List> getAllPersons(int login_id) async {
    Database dbPerson = await databases.db;
    List listMap = await dbPerson.rawQuery("SELECT * FROM $personTable WHERE login_id=$login_id");
    List<Person> listPerson = List();
    for(Map m in listMap){
      listPerson.add(Person.fromMap(m));
    }
    return listPerson;
  }

  Future close() async {
    Database dbPerson = await databases.db;
    dbPerson.close();
  }

}

class Person {

  int id;
  String nome;
  String telefone;
  int login_id;

  Person();

  Person.fromMap(Map map){
    id = map[idPersonColumn];
    nome = map[nomePersonColumn];
    telefone = map[telefonePersonColumn];
    login_id = map[login_idPersonColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomePersonColumn: nome,
      telefonePersonColumn: telefone,
      login_idPersonColumn: login_id
    };
    if(id != null){
      map[idPersonColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Person(id: $id, name: $nome, telefone: $telefone)";
  }

}