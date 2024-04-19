import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';

class DBMaterias {
  static Future<int> insertar(Materia materia) async {
    final db = await Conexion.database;
    return db.insert('MATERIA', materia.toJSON());
  }

  static Future<List<Materia>> mostrar() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> materias = await db.query('MATERIA');
    return List.generate(
        materias.length,
        (index) => Materia(
            nmat: materias[index]['NMAT'],
            descripcion: materias[index]['DESCRIPCION']));
  }

  static Future<int> actualizar(Materia materia) async {
    final db = await Conexion.database;
    return db.update('MATERIA', materia.toJSON(),
        where: 'NMAT=?', whereArgs: [materia.nmat]);
  }
}
