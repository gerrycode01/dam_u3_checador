
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:flutter/material.dart';

import 'package:dam_u3_practica1_checador/modelo/materia.dart';

class VistaMateria extends StatefulWidget {
  const VistaMateria({super.key});

  @override
  State<VistaMateria> createState() => _VistaMateriaState();
}

class _VistaMateriaState extends State<VistaMateria> {
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

  void cargarLista() async {
    List<Materia> l = await DBMaterias.mostrar();
    setState(() {
      materias = l;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarLista();
  }

  void _showAddMateriaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Materia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    hintText: 'Código de la Materia',
                  ),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripción de la Materia',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
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
                 cargarLista();
               });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMateriaDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: materias.length, // Asumiendo que tienes 10 materias por ahora
        itemBuilder: (context, index) {
          // Aquí iría tu código para generar la lista de materias
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(materias[index].descripcion),
              leading: CircleAvatar(child: Text(materias[index].nmat),),// Mostrar información de la materia aquí
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar la materia
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Lógica para eliminar la materia
                      setState(() {
                        // Aquí eliminarías la materia de tu lista o base de datos
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s),backgroundColor: color,
        )
    );
  }
}
