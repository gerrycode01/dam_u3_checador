import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesorHorario.dart';
import 'package:flutter/material.dart';

class Query1 extends StatefulWidget {
  const Query1({super.key});

  @override
  State<Query1> createState() => _Query1State();
}

class _Query1State extends State<Query1> {
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;
  List<ProfesorHorario> profesores = [];
  String? selectedTime;
  String? selectedEdificio;
  String? selectedSalon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: (Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Hora",
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
                  items: Conexion.horas
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Edificio",
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
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco,
              backgroundColor: naranja,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              cargarProfesores();
              // Añadir lógica de búsqueda aquí si es necesario
            },
            child: const Text('Buscar'),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: profesores.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(profesores[index].nombre),
                    );
                  }))
        ],
      )),
    );
  }

  void cargarProfesores() async {
    if (selectedTime == null || selectedEdificio == null) return;

    List<ProfesorHorario> profesores = await DBProfesor.query1(
        selectedTime.toString(), selectedEdificio.toString());

    for (var element in profesores) {
      print(element.nombre);
    }
    setState(() {
      this.profesores = profesores;
    });
  }
}
