import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';

class DBHorario {
  static Future<int> insertar(Horario horario) async {
    final db = await Conexion.database;
    return db.insert('HORARIO', horario.toJSON());
  }

  static Future<List<Horario>> mostrar() async {
    final db = await Conexion.database;
    List<Map<String, dynamic>> horarios = await db.query('HORARIOS');
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
}
