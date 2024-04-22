import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/horarioProfesorMateria.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:dam_u3_practica1_checador/vista/horarios/registrarHorarios.dart';
import 'package:flutter/material.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<HorarioProfesorMateria> horarios = [];

  @override

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarlista();
  }

  void cargarlista() async {
    List<HorarioProfesorMateria> l = await DBHorario.mostrarHorarioCompleto();
    setState(() {
      horarios = l;
    });
  }


  Widget build(BuildContext context) {
    cargarlista();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Horarios'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarHorarios()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: horarios.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(horarios[index].nombreProfesor),
              leading: CircleAvatar(child: Text("${horarios[index].nhorario}"),),
              subtitle: Text(horarios[index].descripcionMateria),
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar Eliminación'),
                            content: const Text('¿Estás seguro de que quieres eliminar este profesor?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
                                },
                              ),
                              TextButton(
                                child: const Text('Eliminar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  DBHorario.eliminar(horarios[index].nhorario).then((value) {
                                    mensaje("SE HA ELIMINADO EL PROFESOR", Colors.red);
                                    cargarlista();
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
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s),backgroundColor: color,
        )
    );
  }
}
