import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';


class RegistrarAsistencias extends StatefulWidget {
  const RegistrarAsistencias({super.key});

  @override
  State<RegistrarAsistencias> createState() => _RegistrarAsistenciasState();
}

class _RegistrarAsistenciasState extends State<RegistrarAsistencias> {
  final _fechaController = TextEditingController();
  final _profesorController = TextEditingController();
  final _asistenciaController = TextEditingController();
  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _fechaController.dispose();
    _profesorController.dispose();
    _asistenciaController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Sistencia"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
