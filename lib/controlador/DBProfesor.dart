import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesorHorario.dart';

class DBProfesor {
  static Future<int> insertar(Profesor profesor) async {
    final db = await Conexion.database;

    Profesor profe = await mostrarUno(profesor.nprofesor);
    if (profe.nombre.isEmpty) {
      return 0;
    }
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
    return db.update('PROFESOR', profesor.toJSON2(),
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

  static Future<List<ProfesorHorario>> query1(
      String hora, String edificio) async {
    final db = await Conexion.database;
    // Uso de parámetros para evitar inyección SQL
    String sql = '''
      SELECT 
        PROFESOR.NPROFESOR, PROFESOR.NOMBRE, PROFESOR.CARRERA,
        HORARIO.NHORARIO, HORARIO.NMAT, HORARIO.HORA, 
        HORARIO.EDIFICIO, HORARIO.SALON
      FROM PROFESOR
      INNER JOIN HORARIO ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      WHERE HORARIO.HORA = ? AND HORARIO.EDIFICIO = ?;
    ''';
    // Ejecución de la consulta con parámetros seguros
    List<Map<String, dynamic>> resultado =
        await db.rawQuery(sql, [hora, edificio]);
    return List.generate(
        resultado.length,
        (index) => ProfesorHorario(
            nprofesor: resultado[index]['NPROFESOR'],
            nombre: resultado[index]['NOMBRE'],
            carrera: resultado[index]['CARRERA'],
            nhorario: resultado[index]['NHORARIO'],
            nmat: resultado[index]['NMAT'],
            hora: resultado[index]['HORA'],
            edificio: resultado[index]['EDIFICIO'],
            salon: resultado[index]['SALON']));
  }

  static Future<List<Profesor>> query2(String fecha) async {
    final db = await Conexion.database;
    String sql = '''
      SELECT PROFESOR.NPROFESOR, PROFESOR.NOMBRE, PROFESOR.CARRERA
      FROM PROFESOR 
      INNER JOIN HORARIO ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      INNER JOIN ASISTENCIA ON ASISTENCIA.NHORARIO = HORARIO.NHORARIO
      WHERE ASISTENCIA.FECHA = ?
      GROUP BY PROFESOR.NPROFESOR
    ''';
    List<Map<String, dynamic>> resultado = await db.rawQuery(sql, [fecha]);
    return List.generate(
        resultado.length,
        (index) => Profesor(
            nprofesor: resultado[index]['NPROFESOR'],
            nombre: resultado[index]['NOMBRE'],
            carrera: resultado[index]['CARRERA']));
  }
}
