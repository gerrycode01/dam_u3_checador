import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';

class VistaProfesor extends StatefulWidget {
  const VistaProfesor({super.key});

  @override
  State<VistaProfesor> createState() => _VistaProfesorState();
}

class _VistaProfesorState extends State<VistaProfesor> {
  List<Profesor> listaProfesor = [];

  final _numeroProfesor = TextEditingController();
  final _nombreController = TextEditingController();
  final _carreraController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  @override
  void dispose() {
    _numeroProfesor.dispose();
    _nombreController.dispose();
    _carreraController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Profesor> l = await DBProfesor.mostrar();
    setState(() {
      listaProfesor = l;
    });
  }

  void _showAddProfesorDialog() {
    limpiarCampos();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(30),
          children: [
            TextField(
              controller: _numeroProfesor,
              decoration: const InputDecoration(
                hintText: 'Numero del Profesor',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                hintText: 'Nombre del Profesor',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _carreraController,
              decoration: const InputDecoration(
                hintText: 'Carrera',
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
                Profesor p = Profesor(
                  nprofesor: _numeroProfesor.text,
                  nombre: _nombreController.text,
                  carrera: _carreraController.text,
                );
                DBProfesor.insertar(p).then((value) {
                  if (value == 0) {
                    mensaje('INSERCION INCORRECTA', Colors.red);
                    return;
                  }
                  mensaje("SE HA INSERTADO EL PROFESOR", Colors.green);
                  limpiarCampos();
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

  void _editar(int index) {
    Profesor p = listaProfesor[index];
    _numeroProfesor.text = p.nprofesor;
    _nombreController.text = p.nombre;
    _carreraController.text = p.carrera;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(30),
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                hintText: 'Nombre del Profesor',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _carreraController,
              decoration: const InputDecoration(
                hintText: 'Carrera',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                limpiarCampos();
              },
            ),
            TextButton(
              child: const Text('Actualizar'),
              onPressed: () {
                p.nombre = _nombreController.text;
                p.carrera = _carreraController.text;
                DBProfesor.actualizar(p).then((value) {
                  if (value == 0) {
                    mensaje('NO SE ACTUALIZO EL REGISTRO', Colors.red);
                    return;
                  }
                  mensaje("SE HA ACTUALIZADO EL PROFESOR", Colors.blue);
                  limpiarCampos();
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
        itemCount: listaProfesor.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(listaProfesor[index].nombre),
              subtitle: Text(listaProfesor[index].carrera),
              leading:
                  CircleAvatar(child: Text(listaProfesor[index].nprofesor)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editar(index);
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
                                  DBProfesor.eliminar(listaProfesor[index].nprofesor).then((value) {
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
                  ,
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

  void limpiarCampos() {
    _numeroProfesor.clear();
    _nombreController.clear();
    _carreraController.clear();
  }
}
