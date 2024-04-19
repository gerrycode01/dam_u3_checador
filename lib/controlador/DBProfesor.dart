import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';

class DBProfesor {
  static Future<int> insertar(Profesor profesor) async {
    final db = await Conexion.database;
    return db.insert('PROFESOR', profesor.toJSON());
  }

  static Future<List<Profesor>> mostrar() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> profesores = await db.query('PROFESOR');
    return List.generate(
        profesores.length,
        (index) => Profesor(
            nprofesor: profesores[index]['NPROFESOR'],
            nombre: profesores[index]['NOMBRE'],
            carrera: profesores[index]['CARRERA']));
  }

  static Future<int> actualizar(Profesor profesor) async {
    final db = await Conexion.database;
    return db.update('PROFESOR', profesor.toJSON(),
        where: 'NPROFESOR=?', whereArgs: [profesor.nprofesor]);
  }
}
