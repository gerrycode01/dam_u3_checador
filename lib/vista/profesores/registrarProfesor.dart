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

  // Definiendo la paleta de colores
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;

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
        title: Text("Registrar Profesor", style: TextStyle(color: blanco),),
        centerTitle: true,
        backgroundColor: azulMarino,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _numeroProfesor,
            decoration: InputDecoration(
              hintText: 'Número del Profesor',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.confirmation_number, color: azulMarino),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              hintText: 'Nombre del Profesor',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.person, color: azulMarino),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: blanco,
              prefixIcon: Icon(Icons.school, color: azulMarino),
            ),
            value: _carreraSeleccionada,
            hint: Text('Seleccione una carrera', style: TextStyle(color: negro.withOpacity(0.6))),
            onChanged: (String? newValue) {
              setState(() {
                _carreraSeleccionada = newValue;
              });
            },
            items: carreras.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: negro)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco, backgroundColor: naranja,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (_carreraSeleccionada == null) {
                mensaje("Por favor, seleccione una carrera antes de agregar.", Colors.red);
              }else {
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
            child: const Text('Agregar'),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: blanco, backgroundColor: azulMarino, // Color de fondo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), backgroundColor: color));
  }

  void limpiarCampos() {
    _numeroProfesor.clear();
    _nombreController.clear();
    _carreraSeleccionada = null;
  }
}
