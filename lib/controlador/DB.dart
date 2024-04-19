import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDB();
    return _database!;
  }

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'checador.db'),
        onCreate: (db, version) {
      return script(db);
    }, version: 1);
  }

  static Future<void> script(Database db) async {
    await db.execute('''
      CREATE TABLE MATERIA(
        NMAT TEXT PRIMARY KEY,
        DESCRIPCION TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE PROFESOR(
        NPROFESOR TEXT,
        NOMBRE TEXT,
        CARRERA TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE HORARIO(
        NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT,
        NPROFESOR TEXT,
        NMAT TEXT,
        HORA TEXT,
        EDIFICIO TEXT,
        SALON TEXT,
        FOREIGN KEY(NPROFESOR) REFERENCES PROFESOR(NPROFESOR),
        FOREIGN KEY(NMAT) REFERENCES MATERIA(NMAT)
      );
    ''');
    await db.execute('''
      CREATE TABLE ASISTENCIA(
        IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT,
        NHORARIO INTEGER,
        FECHA TEXT,
        ASISTENCIA BOOLEAN,
        FOREIGN KEY(NHORARIO) REFERENCES HORARIO(NHORARIO)
      );
    ''');
  }
}
