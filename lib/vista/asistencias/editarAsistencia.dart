import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditarAsistencia extends StatefulWidget {
  const EditarAsistencia({super.key, required this.nhorario});
  final int nhorario;
  @override
  State<EditarAsistencia> createState() => _EditarAsistenciaState();
}

class _EditarAsistenciaState extends State<EditarAsistencia> {
  HorarioProfesorMateria hpm = HorarioProfesorMateria(
      nhorario: 0,
      nprofesor: '',
      nombreProfesor: '',
      nmat: '',
      descripcionMateria: '',
      hora: '',
      edificio: '',
      salon: '');
  String profesor = '';
  DateTime now = DateTime.now();
  String formattedDate = '';
  void initState() {

    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    HorarioProfesorMateria hpm =
    await DBHorario.mostrarHorarioCompletoSolo(widget.nhorario);

    setState(() {
      this.hpm = hpm;
      profesor = this.hpm.nombreProfesor;
      formattedDate = now.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrar Asistencia",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BIENVENIDO PROFESOR $profesor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('HOY ES $formattedDate'),
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
                        idasistencia: 0,
                        nhorario: widget.nhorario,
                        fecha: formattedDate,
                        asistencia: true);
                    DBAsistencia.insertar(asistencia).then((value){
                      if(value == 0){
                        mensaje('ERROR', Colors.red);
                        return;
                      }
                      mensaje('ASISTENCIA REGISTRADA', Colors.green);
                    });
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 10),
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
                        idasistencia: 0,
                        nhorario: widget.nhorario,
                        fecha: formattedDate,
                        asistencia: false);
                    DBAsistencia.insertar(asistencia).then((value){
                      if(value == 0){
                        mensaje('ERROR', Colors.red);
                        return;
                      }
                      mensaje('ASISTENCIA REGISTRADA', Colors.orange);
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
