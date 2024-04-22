import 'package:flutter/material.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/vista/materias/registrarmateria.dart';
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
    _codigoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void cargarLista() async {
    List<Materia> l = await DBMaterias.mostrar();
    setState(() {
      materias = l;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarLista();
  }

  void _showAddMateriaDialog() {
    limpiarCampos();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código de la Materia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción de la Materia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepOrange, // foreground (text color)
                ),
                onPressed: () {
                  Materia m = Materia(
                      nmat: _codigoController.text,
                      descripcion: _descripcionController.text);
                  DBMaterias.insertar(m).then((value) {
                    mensaje("SE HA INSERTADO LA MATERIA", Colors.green);
                    cargarLista();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: _codigoController,
                decoration: InputDecoration(
                  labelText: 'Código de la Materia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción de la Materia',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.update),
                label: const Text('Actualizar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepOrange, // foreground
                ),
                onPressed: () {
                  m.nmat = _codigoController.text;
                  m.descripcion = _descripcionController.text;
                  DBMaterias.actualizar(m).then((value) {
                    mensaje("SE HA ACTUALIZADO LA MATERIA", Colors.blue);
                    cargarLista();
                  });
                  Navigator.pop(context);
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
    cargarLista();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materias',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo.shade900,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.deepOrange),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarMateria()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(materias[index].nmat),
            onDismissed: (direction) {
              DBMaterias.eliminar(materias[index].nmat).then((value) {
                mensaje("Materia eliminada correctamente", Colors.red);
                cargarLista();
              });
            },
            background: Container(color: Colors.red),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                title: Text(materias[index].descripcion),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Text(materias[index].nmat, style: TextStyle(color: Colors.white)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      onPressed: () => _editarMateria(index),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void mensaje(String s, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), backgroundColor: color));
  }

  void limpiarCampos() {
    _codigoController.clear();
    _descripcionController.clear();
  }
}
