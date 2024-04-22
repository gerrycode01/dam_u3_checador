import 'package:dam_u3_practica1_checador/controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:dam_u3_practica1_checador/modelo/todo.dart';
import 'package:dam_u3_practica1_checador/vista/asistencias/editarAsistencia.dart';
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
        title: const Text('Gestión de Asistencia',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: ListView.builder(
        itemCount: asistencias.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Text(
                  "${asistencias[index].idasistencia}",style: TextStyle(color: Colors.white),),
              ),
              title: Text(asistencias[index].nombreProfesor),
              subtitle: Text(
                  '${asistencias[index].fecha} - Asistió: ${asistencias[index].asistencia ? 'SI' : 'NO'}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepOrange),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditarAsistencia(nhorario: asistencias[index].nhorario)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,color: Colors.red),
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
