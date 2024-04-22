import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';

class DBHorario {
  static Future<int> insertar(Horario horario) async {
    final db = await Conexion.database;
    return db.insert('HORARIO', horario.toJSON());
  }

  /*static Future<List<Horario>> mostrar() async {
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
  }*/

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

  static Future<List<HorarioProfesorMateria>> mostrarHorarioCompleto() async {
    final db = await Conexion.database;
    String sql = '''
      SELECT 
      HORARIO.NHORARIO, 
      HORARIO.NPROFESOR, 
      PROFESOR.NOMBRE, 
      HORARIO.NMAT,
      MATERIA.DESCRIPCION,
      HORARIO.HORA,
      HORARIO.EDIFICIO,
      HORARIO.SALON
      FROM HORARIO
      INNER JOIN PROFESOR ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      INNER JOIN MATERIA ON MATERIA.NMAT = HORARIO.NMAT;
    ''';
    List<Map<String, dynamic>> horarioCompleto = await db.rawQuery(sql);

    if (horarioCompleto.isEmpty) {
      return List.generate(
          0,
          (index) => HorarioProfesorMateria(
              nhorario: 0,
              nprofesor: '',
              nombreProfesor: '',
              nmat: '',
              descripcionMateria: '',
              hora: '',
              edificio: '',
              salon: ''));
    }

    return List.generate(
        horarioCompleto.length,
        (index) => HorarioProfesorMateria(
            nhorario: horarioCompleto[index]['NHORARIO'],
            nprofesor: horarioCompleto[index]['NPROFESOR'],
            nombreProfesor: horarioCompleto[index]['NOMBRE'],
            nmat: horarioCompleto[index]['NMAT'],
            descripcionMateria: horarioCompleto[index]['DESCRIPCION'],
            hora: horarioCompleto[index]['HORA'],
            edificio: horarioCompleto[index]['EDIFICIO'],
            salon: horarioCompleto[index]['SALON']));
  }

  static Future<HorarioProfesorMateria> mostrarHorarioCompletoSolo(int nhorario) async {
    final db = await Conexion.database;
    String sql = '''
      SELECT 
      HORARIO.NHORARIO, 
      HORARIO.NPROFESOR, 
      PROFESOR.NOMBRE, 
      HORARIO.NMAT,
      MATERIA.DESCRIPCION,
      HORARIO.HORA,
      HORARIO.EDIFICIO,
      HORARIO.SALON
      FROM HORARIO
      INNER JOIN PROFESOR ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      INNER JOIN MATERIA ON MATERIA.NMAT = HORARIO.NMAT
      WHERE HORARIO.NHORARIO = ? ;
    ''';
    List<Map<String, dynamic>> horarioCompleto = await db.rawQuery(sql,[nhorario]);

    if (horarioCompleto.isEmpty) {
      return HorarioProfesorMateria(
              nhorario: 0,
              nprofesor: '',
              nombreProfesor: '',
              nmat: '',
              descripcionMateria: '',
              hora: '',
              edificio: '',
              salon: '');
    }

    return HorarioProfesorMateria(
            nhorario: horarioCompleto[0]['NHORARIO'],
            nprofesor: horarioCompleto[0]['NPROFESOR'],
            nombreProfesor: horarioCompleto[0]['NOMBRE'],
            nmat: horarioCompleto[0]['NMAT'],
            descripcionMateria: horarioCompleto[0]['DESCRIPCION'],
            hora: horarioCompleto[0]['HORA'],
            edificio: horarioCompleto[0]['EDIFICIO'],
            salon: horarioCompleto[0]['SALON']);
  }
}
