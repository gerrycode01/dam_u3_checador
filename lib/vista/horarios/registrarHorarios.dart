import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class RegistrarHorarios extends StatefulWidget {
  const RegistrarHorarios({super.key});

  @override
  State<RegistrarHorarios> createState() => _RegistrarHorariosState();
}

class _RegistrarHorariosState extends State<RegistrarHorarios> {
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  String? idProfesor;
  String? idMateria;
  String? selectedTime;
  String? selectedEdificio;
  String? selectedSalon;
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarMaterias();
    cargarProfesores();
  }

  void cargarProfesores() async {
    List<Profesor> profesoresList = await DBProfesor.mostrar();
    setState(() {
      profesores = profesoresList;
    });
  }

  void cargarMaterias() async {
    List<Materia> materiasList = await DBMaterias.mostrar();
    setState(() {
      materias = materiasList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Horario",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: azulMarino,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.person, color: azulMarino),
              filled: true,
              fillColor: blanco,
            ),
              hint: const Text("Selecciona un profesor"),
              items: profesores.map((profesor) {
                return DropdownMenuItem(
                    value: profesor.nprofesor, child: Text(profesor.nombre));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  idProfesor = valor!;
                });
              }),
          const SizedBox(height: 20),
          DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.book, color: azulMarino),
                filled: true,
                fillColor: blanco,
              ),
              hint: const Text("Selecciona una materia"),
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
          decoration: InputDecoration(
          labelText: "Selecciona una hora",
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(Icons.punch_clock, color: azulMarino),
          filled: true,
          fillColor: blanco,
          ),
            onChanged: (newValue) {
              setState(() {
                selectedTime = newValue;
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
            decoration: InputDecoration(
              labelText: "Selecciona un edificio",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.apartment, color: azulMarino),
              filled: true,
              fillColor: blanco,
            ),
            value: selectedEdificio,
            onChanged: (newValue) {
              setState(() {
                selectedEdificio = newValue;
                selectedSalon =
                null; // Resetea el salón cuando cambia el edificio
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
              decoration: InputDecoration(
                labelText: "Selecciona un salon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.class_outlined, color: azulMarino),
                filled: true,
                fillColor: blanco,
              ),
              value: selectedSalon,
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

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco, backgroundColor: naranja,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
              
            ),
            child: const Text('Agregar'),
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
              DBHorario.insertar(horario).then((value){
                if(value == 0){
                  mensaje('ERROR DE INSERSION', Colors.red);
                  return;
                }
                mensaje('HORARIO AGREGADO', Colors.green);
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: blanco, backgroundColor: azulMarino,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s), backgroundColor: color,
        )
    );
  }
}
