import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/todo.dart';
import 'package:flutter/material.dart';

class EditarAsistencia extends StatefulWidget {
  const EditarAsistencia({super.key, required this.nhorario});

  final int nhorario;

  @override
  State<EditarAsistencia> createState() => _EditarAsistenciaState();
}

class _EditarAsistenciaState extends State<EditarAsistencia> {
  Todo todo = Todo(
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

  String profesor = '';
  String fecha = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    Todo todo = await DBAsistencia.todoUno(widget.nhorario);

    setState(() {
      this.todo = todo;
      profesor = this.todo.nombreProfesor;
      fecha = this.todo.fecha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Actualizar asistencia",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BIENVENIDO PROFESOR $profesor',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('FECHA DE ASISTENCIA $fecha'),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Asistí :)'),
                  onPressed: () {
                    Asistencia asistencia = Asistencia(
                        idasistencia: todo.idasistencia,
                        nhorario: widget.nhorario,
                        fecha: fecha,
                        asistencia: true);
                    DBAsistencia.actualizar(asistencia).then((value) {
                      if (value == 0) {
                        mensaje('ERROR', Colors.red);
                        return;
                      }
                      mensaje('CAMBIOS REGISTRADOS', Colors.green);
                    });
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Falté :('),
                  onPressed: () {
                    Asistencia asistencia = Asistencia(
                        idasistencia: todo.idasistencia,
                        nhorario: widget.nhorario,
                        fecha: fecha,
                        asistencia: false);
                    DBAsistencia.actualizar(asistencia).then((value) {
                      if (value == 0) {
                        mensaje('ERROR', Colors.red);
                        return;
                      }
                      mensaje('CAMBIOS REGISTRADOS', Colors.orange);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigo.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
            ),
          ],
        ),
      ),
    );
  }

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s), backgroundColor: color));
  }
}
