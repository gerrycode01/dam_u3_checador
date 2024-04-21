import 'package:dam_u3_practica1_checador/vista/asistencias/registrarAsistencia.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';

class Asistencia extends StatefulWidget {
  const Asistencia({super.key});

  @override
  State<Asistencia> createState() => _AsistenciaState();
}

class _AsistenciaState extends State<Asistencia> {
  List<Asistencia> ListaAsistencia = [];
  final _fechaController = TextEditingController();
  final _profesorController = TextEditingController();
  final _asistenciaController = TextEditingController();
  int asistenciaseleccionada = 0;// Este podría ser un Dropdown o Switch

  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _fechaController.dispose();
    _profesorController.dispose();
    _asistenciaController.dispose();
    super.dispose();
  }

  void _showAddAsistenciaDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 20),
              TextField(
                controller: _profesorController,
                decoration: const InputDecoration(
                  hintText: 'Nombre del Profesor',
                ),
              ),
              const SizedBox(height: 20),
              // Aquí iría tu DropdownButtonFormField si decides implementarlo
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el modal
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
          ),
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
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarAsistencias()));
            },
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