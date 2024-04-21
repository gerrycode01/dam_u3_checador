import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class RegistrarHorarios extends StatefulWidget {
  const RegistrarHorarios({super.key});

  @override
  State<RegistrarHorarios> createState() => _RegistrarHorariosState();
}

List<String> generateTimes() {
  List<String> times = [];
  for (int i = 7; i <= 21; i++) {
    String hour = i.toString().padLeft(2, '0');  // Asegura el formato de dos dígitos
    times.add("$hour:00");
  }
  return times;
}
class _RegistrarHorariosState extends State<RegistrarHorarios> {
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  final _horaController = TextEditingController();
  var idProfesor;
  var idMateria;

  Map<String, List<String>> edificiosYSalones = {
    'CB': ['CB1', 'CB2', 'CB3', 'CB4'],
    'UVP': ['LCUVP1', 'LCUVP2', 'LCUVP3', 'MTI1'],
    'LC': ['TDM', 'ACISCO', 'LCSG', 'LCSO'],
    'UD': ['UD1', 'UD2', 'UD11', 'UD12'],
  };

  String? selectedTime;
  List<String> times = generateTimes();

  String? selectedEdificio;
  String? selectedSalon;

  @override
  void dispose() {
    _horaController.dispose();
    super.dispose();
  }

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
        title: const Text("Registrar Horario"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
              hint: const Text("Selecciona un maestro"),
              value: idProfesor,
              items: profesores.map((e) {
                return DropdownMenuItem(
                    value: e.nprofesor, child: Text(e.nombre));
              }).toList(),
              onChanged: (valor) {
                setState(() {
                  idProfesor = valor!;
                });
              }),
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
            decoration: InputDecoration(
              labelText: 'Selecciona una hora',
              border: OutlineInputBorder(),
            ),
            value: selectedTime,
            onChanged: (newValue) {
              setState(() {
                selectedTime = newValue;
              });
            },
            items: times.map<DropdownMenuItem<String>>((String value) {
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
                print(newValue);
                selectedEdificio = newValue;
                selectedSalon =
                    null; // Resetea el salón cuando cambia el edificio
              });
            },
            items: edificiosYSalones.keys
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
              items: edificiosYSalones[selectedEdificio]!
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
            child: const Text('Agregar'),
            onPressed: () {

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
