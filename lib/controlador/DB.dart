import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Database? _database;

  static Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _openDB();
    return _database!;
  }

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'checador.db'),
      onCreate: (db, version){
      return script(db);
      }, version: 1);
  }

  static Future<void> script(db) async{
    db.execute('''
    CREATE TABLE MATERIA(
      NMAT TEXT PRIMARY KEY,
      DESCRIPCION TEXT
    )
    ''');
    db.execute('''
    CREATE TABLE PROFESOR(
      NPROFESOR TEXT,
      NOMBRE TEXT,
      CARRERA TEXT
    )
    ''');
    db.execute('''
    CREATE TABLE HORARIO(
      NHORARIO INT PRIMARY KEY AUTOINCREMENT,
      NPROFESOR TEXT FOREIGN KEY,
      NMAT TEXT FOREIGN KEY,
      HORA TEXT,
      EDIFICIO TEXT,
      SALON TEXT
    )
    ''');
    db.execute('''
    CREATE TABLE ASISTENCIA(
      IDASISTENCIA INT PRIMARY KEY,
      NHORARIO INT FOREIGN KEY,
      FECHA TEXT,
      ASISTENCIA BOOLEAN
    )
    ''');
  }
}