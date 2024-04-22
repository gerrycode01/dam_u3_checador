import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:dam_u3_practica1_checador/modelo/todo.dart';
import 'package:flutter/material.dart';

class VistaAsistencia extends StatefulWidget {
  const VistaAsistencia({super.key});

  @override
  State<VistaAsistencia> createState() => _VistaAsistenciaState();
}

class _VistaAsistenciaState extends State<VistaAsistencia> {
  List<Todo> asistencias = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async {
    List<Todo> asistencias = await DBAsistencia.todo();

    setState(() {
      this.asistencias = asistencias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Asistencia'),
        backgroundColor: Colors.grey.shade500,
      ),
      body: ListView.builder(
        itemCount: asistencias.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(asistencias[index].idasistencia.toString()),
              ),
              title: Text(asistencias[index].nombreProfesor),
              subtitle: Text(
                  '${asistencias[index].fecha} - Asistió: ${asistencias[index].asistencia ? 'SI' : 'NO'}'),
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
                      DBAsistencia.eliminar(asistencias[index].idasistencia);
                      setState(() {
                        cargarDatos();
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
