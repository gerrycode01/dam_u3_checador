import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/todo.dart';

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
            asistencia: asistencias[index]['ASISTENCIA'] == 1));
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
    List<Map<String, dynamic>> asistencias = await db
        .query('ASISTENCIA', where: 'NHORARIO=?', whereArgs: [nhorario]);
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

  static Future<List<Todo>> todo() async {
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
      HORARIO.SALON,
      ASISTENCIA.IDASISTENCIA,
      ASISTENCIA.FECHA,
      ASISTENCIA.ASISTENCIA
      FROM HORARIO
      INNER JOIN PROFESOR ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      INNER JOIN MATERIA ON MATERIA.NMAT = HORARIO.NMAT
      INNER JOIN ASISTENCIA ON ASISTENCIA.NHORARIO = HORARIO.NHORARIO;
    ''';
    List<Map<String, dynamic>> horarioCompleto = await db.rawQuery(sql);

    if (horarioCompleto.isEmpty) {
      return List.generate(
          0,
          (index) => Todo(
              nhorario: 0,
              nprofesor: '',
              nombreProfesor: '',
              nmat: '',
              descripcionMateria: '',
              hora: '',
              edificio: '',
              salon: '',
              idasistencia: 0,
              fecha: '',
              asistencia: false));
    }

    return List.generate(
        horarioCompleto.length,
        (index) => Todo(
            nhorario: horarioCompleto[index]['NHORARIO'],
            nprofesor: horarioCompleto[index]['NPROFESOR'],
            nombreProfesor: horarioCompleto[index]['NOMBRE'],
            nmat: horarioCompleto[index]['NMAT'],
            descripcionMateria: horarioCompleto[index]['DESCRIPCION'],
            hora: horarioCompleto[index]['HORA'],
            edificio: horarioCompleto[index]['EDIFICIO'],
            salon: horarioCompleto[index]['SALON'],
            idasistencia: horarioCompleto[index]['IDASISTENCIA'],
            fecha: horarioCompleto[index]['FECHA'],
            asistencia: horarioCompleto[index]['ASISTENCIA'] == 1));
  }

  static Future<Todo> todoUno(int nhorario) async {
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
      HORARIO.SALON,
      ASISTENCIA.IDASISTENCIA,
      ASISTENCIA.FECHA,
      ASISTENCIA.ASISTENCIA
      FROM HORARIO
      INNER JOIN PROFESOR ON PROFESOR.NPROFESOR = HORARIO.NPROFESOR
      INNER JOIN MATERIA ON MATERIA.NMAT = HORARIO.NMAT
      INNER JOIN ASISTENCIA ON ASISTENCIA.NHORARIO = HORARIO.NHORARIO
      WHERE HORARIO.NHORARIO = ?;
    ''';
    List<Map<String, dynamic>> horarioCompleto =
        await db.rawQuery(sql, [nhorario]);

    if (horarioCompleto.isEmpty) {
      return Todo(
          nhorario: 0,
          nprofesor: '',
          nombreProfesor: '',
          nmat: '',
          descripcionMateria: '',
          hora: '',
          edificio: '',
          salon: '',
          idasistencia: 0,
          fecha: '',
          asistencia: false);
    }

    return Todo(
        nhorario: horarioCompleto[0]['NHORARIO'],
        nprofesor: horarioCompleto[0]['NPROFESOR'],
        nombreProfesor: horarioCompleto[0]['NOMBRE'],
        nmat: horarioCompleto[0]['NMAT'],
        descripcionMateria: horarioCompleto[0]['DESCRIPCION'],
        hora: horarioCompleto[0]['HORA'],
        edificio: horarioCompleto[0]['EDIFICIO'],
        salon: horarioCompleto[0]['SALON'],
        idasistencia: horarioCompleto[0]['IDASISTENCIA'],
        fecha: horarioCompleto[0]['FECHA'],
        asistencia: horarioCompleto[0]['ASISTENCIA'] == 1);
  }
}
