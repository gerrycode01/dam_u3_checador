import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:flutter/material.dart';

class RegistrarAsistencias extends StatefulWidget {
  const RegistrarAsistencias({super.key, required this.nhorario});

  final int nhorario;

  @override
  State<RegistrarAsistencias> createState() => _RegistrarAsistenciasState();
}

class _RegistrarAsistenciasState extends State<RegistrarAsistencias> {
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

  @override
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Asistencia"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          Text('BIENVENIDO PROFESOR $profesor'),
          const SizedBox(height: 20),
          Text('HOY ES $formattedDate'),
          const SizedBox(height: 20),
          TextButton(
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
          TextButton(
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
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
            },
          ),
        ],
      ),
    );
  }

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s), backgroundColor: color));
  }
}
