import 'package:flutter/material.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  final _profesorController = TextEditingController();
  final _materiaController = TextEditingController();
  final _horaController = TextEditingController();
  final _edificioController = TextEditingController();
  final _salonController = TextEditingController();
  final List<String> _horarios = ['Horario 1', 'Horario 2', 'Horario 3'];

  @override

  void dispose() {
    _profesorController.dispose();
    _materiaController.dispose();
    _horaController.dispose();
    _edificioController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  void _showAddHorarioDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Horario'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _profesorController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Profesor',
                  ),
                ),
                TextField(
                  controller: _materiaController,
                  decoration: const InputDecoration(
                    hintText: 'Materia',
                  ),
                ),
                TextField(
                  controller: _horaController,
                  decoration: const InputDecoration(
                    hintText: 'Hora',
                  ),
                ),
                TextField(
                  controller: _edificioController,
                  decoration: const InputDecoration(
                    hintText: 'Edificio',
                  ),
                ),
                TextField(
                  controller: _salonController,
                  decoration: const InputDecoration(
                    hintText: 'Salón',
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Horarios'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHorarioDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _horarios.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_horarios[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para actualizar el horario
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Acción para eliminar el horario
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
