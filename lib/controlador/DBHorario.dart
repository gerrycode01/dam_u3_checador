import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';

class DBHorario {
  static Future<int> insertar(Horario horario) async {
    final db = await Conexion.database;
    return db.insert('HORARIO', horario.toJSON());
  }

  static Future<List<Horario>> mostrar() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> horarios = await db.query('HORARIO');
    return List.generate(
        horarios.length,
        (index) => Horario(
            nhorario: horarios[index]['NHORARIO'],
            nprofesor: horarios[index]['NPROFESOR'],
            nmat: horarios[index]['NMAT'],
            hora: horarios[index]['HORA'],
            edificio: horarios[index]['EDIFICIO'],
            salon: horarios[index]['SALON']));
  }

  static Future<Horario> mostrarUno(int nhorario) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> horario =
        await db.query('HORARIO', where: 'NHORARIO=?', whereArgs: [nhorario]);
    return Horario(
        nhorario: horario[0]['NHORARIO'],
        nprofesor: horario[0]['NPROFESOR'],
        nmat: horario[0]['NMAT'],
        hora: horario[0]['HORA'],
        edificio: horario[0]['EDIFICIO'],
        salon: horario[0]['SALON']);
  }

  static Future<List<Horario>> mostrarPorProfesor(String nprofesor) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> horarios =
        await db.query('HORARIO', where: 'NPROFESOR=?', whereArgs: [nprofesor]);
    return List.generate(
        horarios.length,
        (index) => Horario(
            nhorario: horarios[index]['NHORARIO'],
            nprofesor: horarios[index]['NPROFESOR'],
            nmat: horarios[index]['NMAT'],
            hora: horarios[index]['HORA'],
            edificio: horarios[index]['EDIFICIO'],
            salon: horarios[index]['SALON']));
  }

  static Future<List<Horario>> mostrarPorMateria(String nmat) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> horarios =
        await db.query('HORARIO', where: 'NMAT=?', whereArgs: [nmat]);
    return List.generate(
        horarios.length,
        (index) => Horario(
            nhorario: horarios[index]['NHORARIO'],
            nprofesor: horarios[index]['NPROFESOR'],
            nmat: horarios[index]['NMAT'],
            hora: horarios[index]['HORA'],
            edificio: horarios[index]['EDIFICIO'],
            salon: horarios[index]['SALON']));
  }

  static Future<int> actualizar(Horario horario) async {
    final db = await Conexion.database;
    return db.update('HORARIO', horario.toJSON(),
        where: 'NHORARIO=?', whereArgs: [horario.nhorario]);
  }

  static Future<int> eliminar(int nhorario) async {
    final db = await Conexion.database;

    //obtengo las asistencias relacionadas con el horario
    List<Asistencia> asistencias =
        await DBAsistencia.mostrarPorHorario(nhorario);

    //Elimino las asistencias relacionadas con ese horario
    for (var asistencia in asistencias) {
      DBAsistencia.eliminar(asistencia.idasistencia);
    }

    return await db
        .delete('HORARIO', where: 'NHORARIO=?', whereArgs: [nhorario]);
  }
}
