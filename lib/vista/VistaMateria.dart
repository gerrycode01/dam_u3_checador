import 'package:flutter/material.dart';

class Materia extends StatefulWidget {
  const Materia({super.key});

  @override
  State<Materia> createState() => _MateriaState();
}

class _MateriaState extends State<Materia> {
  // Controladores de texto para los campos del formulario
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
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
                    hintText: 'Numero de la Materia',
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
                // Aquí deberías añadir la lógica para validar los campos y guardarlos en la base de datos
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
        itemCount: 10, // Asumiendo que tienes 10 materias por ahora
        itemBuilder: (context, index) {
          // Aquí iría tu código para generar la lista de materias
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Materia #${index + 1}'), // Mostrar información de la materia aquí
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
}
