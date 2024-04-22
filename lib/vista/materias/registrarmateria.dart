import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/vista/materias/VistaMateria.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';

class RegistrarMateria extends StatefulWidget {
  const RegistrarMateria({super.key});

  @override
  State<RegistrarMateria> createState() => _RegistrarMateriaState();
}

class _RegistrarMateriaState extends State<RegistrarMateria> {
  List<Materia> materias = [];
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();

  // Definiendo la paleta de colores
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;

  @override
  void dispose() {
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Materias", style: TextStyle(color: blanco)),
        backgroundColor: azulMarino,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _codigoController,
            decoration: InputDecoration(
              hintText: 'Código de la Materia',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.code, color: azulMarino),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descripcionController,
            decoration: InputDecoration(
              hintText: 'Descripción de la Materia',
              hintStyle: TextStyle(color: negro.withOpacity(0.6)),
              filled: true,
              fillColor: blanco,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.description, color: azulMarino),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco, backgroundColor: naranja, // foreground
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Materia m = Materia(
                  nmat: _codigoController.text,
                  descripcion: _descripcionController.text
              );
              DBMaterias.insertar(m).then((value) {
                mensaje("SE HA INSERTADO LA MATERIA", Colors.green);
                Navigator.pop(context);
              });
            },
            child: const Text('Agregar'),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: blanco, backgroundColor: azulMarino, // Background color
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
    _codigoController.clear();
    _descripcionController.clear();
  }
}
