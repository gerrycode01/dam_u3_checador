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

  static Future<int> actualizar(Asistencia asistencia) async {
    final db = await Conexion.database;
    return db.update('ASISTENCIA', asistencia.toJSON(),
        where: 'IDASISTENCIA=?', whereArgs: [asistencia.idasistencia]);
  }
}
