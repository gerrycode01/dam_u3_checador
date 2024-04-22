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

  static Map<String, List<String>> edificiosYSalones = {
    'CB': ['CB1', 'CB2', 'CB3', 'CB4'],
    'UVP': ['LCUVP1', 'LCUVP2', 'LCUVP3', 'MTI1'],
    'LC': ['TDM', 'ACISCO', 'LCSG', 'LCSO'],
    'UD': ['UD1', 'UD2', 'UD11', 'UD12'],
  };

  static List<String> horas = [
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
  ];
}
