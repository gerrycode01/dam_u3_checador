import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';

class RegistrarProfesor extends StatefulWidget {
  const RegistrarProfesor({super.key});

  @override
  State<RegistrarProfesor> createState() => _RegistrarProfesorState();
}

List<String> carreras = [
  "ISC", "IGE", "IC", "IB", "IE", "ID", "IQ", "IM"
];

class _RegistrarProfesorState extends State<RegistrarProfesor> {
  List<Profesor> listaProfesor = [];
  final _numeroProfesor = TextEditingController();
  final _nombreController = TextEditingController();
  String? _carreraSeleccionada;

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  @override
  void dispose() {
    _numeroProfesor.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Profesor> l = await DBProfesor.mostrar();
    setState(() {
      listaProfesor = l;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Profesor"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _numeroProfesor,
            decoration: const InputDecoration(
              hintText: 'Numero del Profesor',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
              hintText: 'Nombre del Profesor',
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _carreraSeleccionada,
            hint: Text('Seleccione una carrera'),
            onChanged: (String? newValue) {
              setState(() {
                _carreraSeleccionada = newValue;
              });
            },
            items: carreras.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
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
              if (_carreraSeleccionada == null) {
                mensaje("Por favor, seleccione una carrera antes de agregar.", Colors.red);
              } else {
                Profesor p = Profesor(
                  nprofesor: _numeroProfesor.text,
                  nombre: _nombreController.text,
                  carrera: _carreraSeleccionada!, // Forzamos que no sea null
                );
                DBProfesor.insertar(p).then((value) {
                  if (value == 0) {
                    mensaje('INSERCION INCORRECTA', Colors.red);
                    return;
                  }
                  mensaje("SE HA INSERTADO EL PROFESOR", Colors.green);
                  limpiarCampos();
                  cargarLista();
                });
                Navigator.pop(context);
              }
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

  void limpiarCampos() {
    _numeroProfesor.clear();
    _nombreController.clear();
    _carreraSeleccionada = null; // Resetear la selección de la carrera
  }
}
