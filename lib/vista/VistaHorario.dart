import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<Horario> horarios = [];
  List<Profesor> profesores = [];
  List<Materia> materias = [];

  final _profesorController = TextEditingController();
  final _materiaController = TextEditingController();
  final _horaController = TextEditingController();
  final _edificioController = TextEditingController();
  final _salonController = TextEditingController();
  final List<String> _horarios = ['Horario 1', 'Horario 2', 'Horario 3'];

  @override

  void dispose() {
    _profesorController.dispose();
    _materiaController.dispose();
    _horaController.dispose();
    _edificioController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void cargarlista() async {
    List<Horario> l = await DBHorario.mostrar();
    setState(() {
      horarios = l;
    });
  }
int profesorseleccionado = 0;
  void _showAddHorarioDialog() {
    // Clear all fields before showing the dialog
    _profesorController.clear();
    _materiaController.clear();
    _horaController.clear();
    _edificioController.clear();
    _salonController.clear();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(30),
          children: [
            DropdownButton(
                items: profesores.map((e) {
                  return DropdownMenuItem(
                      child: Text(e.nombre),
                    value: e.nprofesor,
                  );
                }).toList(),
                onChanged: (valor){
                  setState(() {
                    profesorseleccionado = valor! as int;
                  });
                }
            ),
            SizedBox(height: 20),
            TextField(
              controller: _materiaController,
              decoration: const InputDecoration(
                hintText: 'Materia',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _horaController,
              decoration: const InputDecoration(
                hintText: 'Hora',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _edificioController,
              decoration: const InputDecoration(
                hintText: 'Edificio',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _salonController,
              decoration: const InputDecoration(
                hintText: 'Salón',
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
              child: const Text('Agregar'),
              onPressed: () {
                // Horario nuevoHorario = Horario(
                //   profesor: _profesorController.text,
                //   materia: _materiaController.text,
                //   hora: _horaController.text,
                //   edificio: _edificioController.text,
                //   salon: _salonController.text,
                // );
                // DBHorarios.insertar(nuevoHorario).then((value) {
                //   mensaje("SE HA INSERTADO EL HORARIO", Colors.green);
                //   cargarListaHorarios(); // Asegúrate de tener una función para recargar los horarios
                // });
                Navigator.of(context). pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Horarios'),
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHorarioDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _horarios.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(_horarios[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción para actualizar el horario
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Acción para eliminar el horario
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
