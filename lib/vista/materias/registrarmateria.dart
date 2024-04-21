
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/vista/materias/VistaMateria.dart';
import 'package:flutter/material.dart';

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
  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    limpiarCampos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Materias"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: _codigoController,
            decoration: const InputDecoration(
              hintText: 'Código de la Materia',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _descripcionController,
            decoration: const InputDecoration(
              hintText: 'Descripción de la Materia',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Agregar'),
            onPressed: () {
              Materia m = Materia(
                  nmat: _codigoController.text,
                  descripcion: _descripcionController.text
              );
              DBMaterias.insertar(m).then((value) {
                mensaje("SE HA INSERTADO LA MATERIA", Colors.green);

              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VistaMateria()));
            },
          ),
        ],
      ),
    );
  }
  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s),backgroundColor: color,
        )
    );
  }
  void limpiarCampos() {
    _codigoController.clear();
    _descripcionController.clear();
  }
}
