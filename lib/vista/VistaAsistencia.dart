import 'package:flutter/material.dart';

class Asistencia extends StatefulWidget {
  const Asistencia({super.key});

  @override
  State<Asistencia> createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  // Controladores de texto para los campos del formulario
  final _fechaController = TextEditingController();
  final _profesorController = TextEditingController();
  final _asistenciaController = TextEditingController(); // Este podría ser un Dropdown o Switch

  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _fechaController.dispose();
    _profesorController.dispose();
    _asistenciaController.dispose();
    super.dispose();
  }

  void _showAddAsistenciaDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrar Asistencia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    hintText: 'Fecha',
                  ),
                  onTap: () async {
                    // Mostrar picker de fecha
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _fechaController.text = pickedDate.toString().substring(0, 10); // Formatea la fecha como yyyy-mm-dd
                    }
                  },
                ),
                TextField(
                  controller: _profesorController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Profesor',
                  ),
                ),
                TextField(
                  controller: _asistenciaController,
                  decoration: const InputDecoration(
                    hintText: 'Asistencia (Sí/No)',
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
              child: const Text('Registrar'),
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
        title: const Text('Gestión de Asistencia'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAsistenciaDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Asumiendo que tienes 10 registros de asistencia por ahora
        itemBuilder: (context, index) {
          // Aquí iría tu código para generar la lista de asistencias
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Asistencia #${index + 1}'), // Mostrar información de la asistencia aquí
              subtitle: Text('Profesor: Nombre - Fecha: xxxx-xx-xx - Asistió: Sí/No'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Lógica para editar el registro de asistencia
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Lógica para eliminar el registro de asistencia
                      setState(() {
                        // Aquí eliminarías el registro de tu lista o base de datos
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