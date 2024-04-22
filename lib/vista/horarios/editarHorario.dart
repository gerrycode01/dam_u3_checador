import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';

class EditarHorario extends StatefulWidget {
  const EditarHorario({super.key, required this.nHorario});

  final int nHorario;

  @override
  State<EditarHorario> createState() => _EditarHorarioState();
}

class _EditarHorarioState extends State<EditarHorario> {
  HorarioProfesorMateria horario = HorarioProfesorMateria(
      nhorario: 0,
      nprofesor: '',
      nombreProfesor: '',
      nmat: '',
      descripcionMateria: '',
      hora: '',
      edificio: '',
      salon: ''
  );
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  String? idProfesor;
  String? idMateria;
  String? selectedTime;
  String? selectedEdificio;
  String? selectedSalon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarlista();
  }

  void cargarlista() async {
    HorarioProfesorMateria l =
        await DBHorario.mostrarHorarioCompletoSolo(widget.nHorario);
    List<Profesor> p = await DBProfesor.mostrar();
    List<Materia> ma = await DBMaterias.mostrar();
    setState(() {
      horario = l;
      materias = ma;
      profesores = p;
      idProfesor = horario.nprofesor;
      print('$idProfesor - ${horario.nombreProfesor}');
      idMateria = horario.nmat;
      print('$idMateria - ${horario.descripcionMateria}');
      selectedTime = horario.hora;
      print(selectedTime);
      selectedEdificio = horario.edificio;
      print(selectedEdificio);
      selectedSalon = horario.salon;
      print(selectedSalon);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Horario"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
            hint: const Text("Selecciona un profesor"),
            value: idProfesor, // Asegúrate de que esta sea una variable que refleje el valor actual seleccionado y sea única
            items: profesores.map((Profesor profesor) {
              return DropdownMenuItem<String>(
                value: profesor.nprofesor, // Este valor debe ser único para cada profesor
                child: Text(profesor.nombre),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                idProfesor = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
              hint: const Text("Selecciona una materia"),
              value: idMateria,
              items: materias.map((e) {
                return DropdownMenuItem(
                    value: e.nmat, child: Text(e.descripcion));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  idMateria = valor!;
                });
              }),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedTime,
            decoration: const InputDecoration(
              labelText: 'Selecciona una hora',
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) {
              setState(() {
                selectedTime = newValue!;
              });
            },
            items: Conexion.horas.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedEdificio,
            hint: const Text("Selecciona un edificio"),
            onChanged: (newValue) {
              setState(() {
                selectedEdificio = newValue!;
                selectedSalon = null;
              });
            },
            items: Conexion.edificiosYSalones.keys
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (selectedEdificio != null) ...[
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedSalon,
              hint: const Text("Selecciona un salón"),
              onChanged: (newValue) {
                setState(() {
                  selectedSalon = newValue;
                });
              },
              items: Conexion.edificiosYSalones[selectedEdificio]!
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Actualizar'),
            onPressed: () {
              if (idProfesor == null) {
                mensaje('SELECCIONA UN PROFESOR', Colors.red);
                return;
              }
              if (idMateria == null) {
                mensaje('SELECCIONA UNA MATERIA', Colors.red);
                return;
              }
              if (selectedTime == null) {
                mensaje('SELECCIONA UNA HORA', Colors.red);
                return;
              }
              if (selectedEdificio == null) {
                mensaje('SELECCIONA UN EDIFICIO', Colors.red);
                return;
              }
              if (selectedSalon == null) {
                mensaje('SELECCIONA UN SALON', Colors.red);
                return;
              }
              Horario horario = Horario(
                  nhorario: 0,
                  nprofesor: idProfesor.toString(),
                  nmat: idMateria.toString(),
                  hora: selectedTime.toString(),
                  edificio: selectedEdificio.toString(),
                  salon: selectedSalon.toString());
              DBHorario.actualizar(horario).then((value) {
                if (value == 0) {
                  mensaje('ERROR DE ACTUALIZACION', Colors.red);
                  return;
                }
                mensaje('HORARIO ACTUALIZADO', Colors.green);
              });
              Navigator.of(context).pop();
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
