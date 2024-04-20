import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class Profesor extends StatefulWidget {
  const Profesor({super.key});

  @override
  State<Profesor> createState() => _ProfesorState();
}

class _ProfesorState extends State<Profesor> {
  List<Profesor> ListaProfesor = [];

  final _numeroProfesor = TextEditingController();
  final _nombreController = TextEditingController();
  final _carreraController = TextEditingController();

  @override
  void dispose() {
    _numeroProfesor.dispose();
    _nombreController.dispose();
    _carreraController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Profesor> l = (await DBProfesor.mostrar()).cast<Profesor>();
    setState(() {
      ListaProfesor = l;
    });
  }

  void _showAddProfesorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Profesor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _numeroProfesor,
                  decoration: const InputDecoration(
                    hintText: 'Numero del Profesor',
                  ),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Profesor',
                  ),
                ),
                TextField(
                  controller: _carreraController,
                  decoration: const InputDecoration(
                    hintText: 'Carrera',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
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
        title: const Text('Gestión de Profesores'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddProfesorDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Profesor #${index + 1}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {

                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
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
