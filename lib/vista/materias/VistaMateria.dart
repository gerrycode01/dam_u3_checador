
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/vista/materias/registrarmateria.dart';
import 'package:flutter/material.dart';

import 'package:dam_u3_practica1_checador/modelo/materia.dart';

class VistaMateria extends StatefulWidget {
  const VistaMateria({super.key});

  @override
  State<VistaMateria> createState() => _VistaMateriaState();
}

class _VistaMateriaState extends State<VistaMateria> {
  List<Materia> materias = [];
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    // Limpia los controladores cuando el Widget se descarte
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Materia> l = await DBMaterias.mostrar();
    setState(() {
      materias = l;
    });
    print("Materias cargadas: ${materias.length}"); // Esto imprimirá la cantidad de materias cargadas
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarLista();
  }

  void _showAddMateriaDialog() {
    limpiarCampos(); // Asegúrate de que esta función limpia los controladores de texto
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(30),
          children: [
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                hintText: 'Código de la Materia',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                hintText: 'Descripción de la Materia',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                Materia m = Materia(
                    nmat: _codigoController.text,
                    descripcion: _descripcionController.text
                );
                DBMaterias.insertar(m).then((value) {
                  mensaje("SE HA INSERTADO LA MATERIA", Colors.green);
                  cargarLista();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _editarMateria(int index) {
    Materia m = materias[index];
    _codigoController.text = m.nmat;
    _descripcionController.text = m.descripcion;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(30),
          children: [
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                hintText: 'Código de la Materia',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                hintText: 'Descripción de la Materia',
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () {
                m.nmat = _codigoController.text;
                m.descripcion = _descripcionController.text;
                DBMaterias.actualizar(m).then((value) {
                  mensaje("SE HA ACTUALIZADO LA MATERIA", Colors.blue);
                  cargarLista();
                });
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
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarMateria()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: materias.length, // Asumiendo que tienes 10 materias por ahora
        itemBuilder: (context, index) {
          // Aquí iría tu código para generar la lista de materias
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(materias[index].descripcion),
              leading: CircleAvatar(child: Text(materias[index].nmat),),// Mostrar información de la materia aquí
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editarMateria(index);
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
                                  Navigator.of(context).pop(); // Cierra el diálogo
                                  // Aquí se realiza la eliminación después de la confirmación
                                  DBMaterias.eliminar(materias[index].nmat).then((value) {
                                    mensaje("SE HA ELIMINADO EL PROFESOR", Colors.red);
                                    cargarLista(); // Refresca la lista después de eliminar
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
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
  void limpiarCampos() {
    _codigoController.clear();
    _descripcionController.clear();
  }
}
