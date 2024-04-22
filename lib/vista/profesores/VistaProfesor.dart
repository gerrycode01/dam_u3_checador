import 'package:dam_u3_practica1_checador/vista/profesores/registrarProfesor.dart';
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

  void _editar(int index) {
    Profesor p = listaProfesor[index];
    _numeroProfesor.text = p.nprofesor;
    _nombreController.text = p.nombre;
    _carreraController.text = p.carrera;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Profesor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _carreraController,
                decoration: const InputDecoration(
                  labelText: 'Carrera',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Actualizar'),
                onPressed: () {
                  p.nombre = _nombreController.text;
                  p.carrera = _carreraController.text;
                  DBProfesor.actualizar(p).then((value) {
                    if (value == 0) {
                      mensaje('No se actualizó el registro', Colors.red);
                    } else {
                      mensaje("Profesor actualizado correctamente", Colors.blue);
                      cargarLista();
                    }
                    Navigator.pop(context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    cargarLista();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Profesores',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarProfesor()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: listaProfesor.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(listaProfesor[index].nprofesor),
            onDismissed: (direction) {
              DBProfesor.eliminar(listaProfesor[index].nprofesor).then((value) {
                mensaje("Profesor eliminado correctamente", Colors.red);
                cargarLista();
              });
            },
            background: Container(color: Colors.red),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text(listaProfesor[index].nombre),
                subtitle: Text('Carrera: ${listaProfesor[index].carrera}'),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Text(listaProfesor[index].nprofesor,style: TextStyle(color: Colors.white),),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.deepOrange),
                  onPressed: () => _editar(index),
                ),
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
