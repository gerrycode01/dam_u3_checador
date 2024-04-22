import 'package:dam_u3_practica1_checador/vista/asistencias/registrarAsistencia.dart';
import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:dam_u3_practica1_checador/vista/horarios/editarHorario.dart';
import 'package:dam_u3_practica1_checador/vista/horarios/registrarHorarios.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<HorarioProfesorMateria> horarios = [];

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  void cargarLista() async {
    List<HorarioProfesorMateria> l = await DBHorario.mostrarHorarioCompleto();
    setState(() {
      horarios = l;
    });
  }

  Widget build(BuildContext context) {
    cargarLista();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Horarios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrarHorarios()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: horarios.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrarAsistencias(
                            nhorario: horarios[index].nhorario)));
              },
              title: Text(horarios[index].nombreProfesor),
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Text("${horarios[index].nhorario}",
                    style: TextStyle(color: Colors.white)),
              ),
              subtitle: Text(
                  "${horarios[index].descripcionMateria} - ${horarios[index].hora} - ${horarios[index].edificio}-${horarios[index].salon}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepOrange),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditarHorario(
                                  nHorario: horarios[index].nhorario)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar Eliminación'),
                            content: const Text(
                                '¿Estás seguro de que quieres eliminar este horario?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('Eliminar'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  DBHorario.eliminar(horarios[index].nhorario)
                                      .then((value) {
                                    mensaje("Horario eliminado correctamente",
                                        Colors.red);
                                    cargarLista();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s), backgroundColor: color));
  }
}
