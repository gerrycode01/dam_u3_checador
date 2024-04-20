import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
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

  static Future<Profesor> mostrarUno(String nprofesor) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> profesor = await db
        .query('PROFESOR', where: 'NPROFESOR=?', whereArgs: [nprofesor]);
    return Profesor(
        nprofesor: profesor[0]['NPROFESOR'],
        nombre: profesor[0]['NOMBRE'],
        carrera: profesor[0]['CARRERA']);
  }

  static Future<int> actualizar(Profesor profesor) async {
    final db = await Conexion.database;
    return db.update('PROFESOR', profesor.toJSON(),
        where: 'NPROFESOR=?', whereArgs: [profesor.nprofesor]);
  }

  static Future<int> eliminar(String nprofesor) async {
    final db = await Conexion.database;

    List<Horario> horarios = await DBHorario.mostrarPorProfesor(nprofesor);
    for (var horario in horarios) {
      DBHorario.eliminar(horario.nhorario);
    }

    return await db
        .delete('PROFESOR', where: 'NPROFESOR=?', whereArgs: [nprofesor]);
  }
}
