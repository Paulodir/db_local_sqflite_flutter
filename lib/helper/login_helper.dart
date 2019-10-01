import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String loginTable = "loginTable";
final String idColumn = "id";
final String nomeColumn = "nome";
final String emailColumn = "email";
final String senhaColumn = "senha";
final String logadoTable = "logadoTable";
final String idLogado = "id";
final String _loginIdLogadoColumn = "login_id";

class LoginHelper {
  static final LoginHelper _instance = LoginHelper.internal();
  factory LoginHelper() => _instance;
  LoginHelper.internal();
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
    final path = join(databasesPath, "contatos6344.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $loginTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nomeColumn TEXT, $emailColumn TEXT, $senhaColumn TEXT);"
      );
      await db.execute(
          "CREATE TABLE $logadoTable ($idLogado INTEGER PRIMARY KEY AUTOINCREMENT,$_loginIdLogadoColumn INT);"
      );
    });
  }

  Future<bool> saveCadastro(String nome, String email, String senha) async {
    Database dbLogin = await db;
    Login login = new Login();
    login.nome = nome;
    login.email = email;
    login.senha = senha;
    if(await dbLogin.insert(loginTable, login.toMap())>0){
      return true;
    }else{
      return false;
    }

  }



  Future<Login> getLogin(String nome,String senha) async {
    Database dbLogin = await db;
    List<Map> maps = await dbLogin.query(loginTable,
        columns: [idColumn, nomeColumn, senhaColumn],
        where: "$nomeColumn = ? AND $senhaColumn = ?",
        whereArgs: [nome,senha]);
    if(maps.length > 0){
      return Login.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLogin(int id) async {
    Database dbLogin = await db;
    return await dbLogin.delete(loginTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLogin(Login login) async {
    Database dbLogin = await db;
    return await dbLogin.update(loginTable,
        login.toMap(),
        where: "$idColumn = ?",
        whereArgs: [login.id]);
  }

  Future<List> getAllLogins() async {
    Database dbLogin = await db;
    List listMap = await dbLogin.rawQuery("SELECT * FROM $loginTable");
    List<Login> listLogin = List();
    for(Map m in listMap){
      listLogin.add(Login.fromMap(m));
    }
    return listLogin;
  }

  Future<bool> saveLogado(int login_id) async {
    Database dbLogado = await db;
    Logado logado = new Logado();
    logado.id=1;
    logado.logado_login_id = login_id;
    if(await dbLogado.insert(logadoTable, logado.toMap())>0) {
      return true;
    }else{
      return false;
    }
  }

  Future<int> getLogado() async{
    Database dbLogado = await db;
    List<Map> maps =  await dbLogado.rawQuery("SELECT * FROM $logadoTable");
    return 1;
    Logado logado = Logado.fromMap(maps.first);
    if(maps.toString() != '[]'){
      return logado.logado_login_id;
    }else{
      return 0;
    }
  }
    Future<int> deleteLogado() async {
    Database dbLogin = await db;
    return await dbLogin.delete(logadoTable);
  }

  Future close() async {
    Database dbLogin = await db;
    dbLogin.close();
  }

}

class Logado {
  int id;
  int logado_login_id;
  Logado();
  Logado.fromMap(Map map){
    id = map[idLogado];
    logado_login_id = map[_loginIdLogadoColumn];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      idColumn: id,
      _loginIdLogadoColumn: logado_login_id
    };
    return map;
  }
}

class Login {
  int id;
  String nome;
  String email;
  String senha;
  Login();
  Login.fromMap(Map map){
    id = map[idColumn];
    email = map[emailColumn];
    nome = map[nomeColumn];
    senha = map[senhaColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      emailColumn: email,
      nomeColumn: nome,
      senhaColumn: senha
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Login(id: $id, name: $nome, email: $email, senha: $senha)";
  }

}
