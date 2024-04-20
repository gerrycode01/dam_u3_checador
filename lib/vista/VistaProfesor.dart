import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class VistaProfesor extends StatefulWidget {
  const VistaProfesor({super.key});

  @override
  State<VistaProfesor> createState() => _VistaProfesorState();
}

class _VistaProfesorState extends State<VistaProfesor> {
  List<Profesor> ListaProfesor = [];

  final _numeroProfesor = TextEditingController();
  final _nombreController = TextEditingController();
  final _carreraController = TextEditingController();

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    cargarLista();
  }

  void dispose() {
    _numeroProfesor.dispose();
    _nombreController.dispose();
    _carreraController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Profesor> l = await DBProfesor.mostrar();
    setState(() {
      ListaProfesor = l;
    });
  }

  void _showAddProfesorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Profesor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _numeroProfesor,
                  decoration: const InputDecoration(
                    hintText: 'Numero del Profesor',
                  ),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Nombre del Profesor',
                  ),
                ),
                TextField(
                  controller: _carreraController,
                  decoration: const InputDecoration(
                    hintText: 'Carrera',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
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
        itemCount: ListaProfesor.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(ListaProfesor[index].nombre),
              subtitle: Text(ListaProfesor[index].carrera),
              leading: CircleAvatar(child: Text(ListaProfesor[index].nprofesor),),
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
                      setState(() {
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
  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s),backgroundColor: color,
        )
    );
  }
  void limpiarCampos() {
    _numeroProfesor.clear();
    _nombreController.clear();
    _carreraController.clear();
  }

}
