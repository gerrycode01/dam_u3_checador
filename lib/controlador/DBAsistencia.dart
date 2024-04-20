import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';

class DBAsistencia {
  static Future<int> insertar(Asistencia asistencia) async {
    final db = await Conexion.database;
    return db.insert('ASISTENCIA', asistencia.toJSON());
  }

  static Future<List<Asistencia>> mostrar() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> asistencias = await db.query('ASISTENCIA');
    return List.generate(
        asistencias.length,
        (index) => Asistencia(
            idasistencia: asistencias[index]['IDASISTENCIA'],
            nhorario: asistencias[index]['NHORARIO'],
            fecha: asistencias[index]['FECHA'],
            asistencia: asistencias[index]['ASISTENCIA']));
  }

  static Future<Asistencia> mostrarUno(int idasistencia) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> asistencia = await db.query('ASISTENCIA',
        where: 'IDASISTENCIA=?', whereArgs: [idasistencia]);
    return Asistencia(
        idasistencia: asistencia[0]['IDASISTENCIA'],
        nhorario: asistencia[0]['NHORARIO'],
        fecha: asistencia[0]['FECHA'],
        asistencia: asistencia[0]['ASISTENCIA']);
  }

  static Future<List<Asistencia>> mostrarPorHorario(int nhorario) async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> asistencias =
        await db.query('ASISTENCIA', where: 'NHORARIO=?', whereArgs: [nhorario]);
    return List.generate(
        asistencias.length,
        (index) => Asistencia(
            idasistencia: asistencias[index]['IDASISTENCIA'],
            nhorario: asistencias[index]['NHORARIO'],
            fecha: asistencias[index]['FECHA'],
            asistencia: asistencias[index]['ASISTENCIA']));
  }

  static Future<int> actualizar(Asistencia asistencia) async {
    final db = await Conexion.database;
    return db.update('ASISTENCIA', asistencia.toJSON(),
        where: 'IDASISTENCIA=?', whereArgs: [asistencia.idasistencia]);
  }

  static Future<int> eliminar(int idasistencia) async {
    final db = await Conexion.database;
    return db.delete('ASISTENCIA',
        where: 'IDASISTENCIA=?', whereArgs: [idasistencia]);
  }
}
