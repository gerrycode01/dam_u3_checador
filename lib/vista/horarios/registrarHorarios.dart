import 'package:dam_u3_practica1_checador/controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/horario.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class RegistrarHorarios extends StatefulWidget {
  const RegistrarHorarios({super.key});

  @override
  State<RegistrarHorarios> createState() => _RegistrarHorariosState();
}

class _RegistrarHorariosState extends State<RegistrarHorarios> {
  List<Horario> horarios = [];
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  int profesorseleccionado = 0;
  final _profesorController = TextEditingController();
  final _materiaController = TextEditingController();
  final _horaController = TextEditingController();
  final _edificioController = TextEditingController();
  final _salonController = TextEditingController();

  var idProfesor;

  var idMateria;

  @override

  void dispose() {
    _profesorController.dispose();
    _materiaController.dispose();
    _horaController.dispose();
    _edificioController.dispose();
    _salonController.dispose();
    super.dispose();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    cargarlista();
  }

  void cargarProfesores() async {
    List<Profesor> profesoresList = await DBProfesor.mostrar();
    setState(() {
      profesores = profesoresList;
    });
  }

  void cargarMaterias() async {
    List<Materia> materiasList = await DBMaterias.mostrar();
    setState(() {
      materias = materiasList;
    });
  }

  void cargarlista() async {
    List<Horario> l = await DBHorario.mostrar();
    setState(() {
      horarios = l;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Horario"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          DropdownButtonFormField(
              value: idProfesor,
              items: profesores.map((e) {
                return DropdownMenuItem(
                    value: e.nprofesor,
                    child: Text(e.nombre)
                );
              }).toList(),
              onChanged: (valor){
                setState(() {
                  idProfesor = valor!;
                });
              }
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: idMateria,
              items: materias.map((e) {
                return DropdownMenuItem(
                  value: e.nmat,
                    child: Text(e.descripcion)
                );
              }).toList(),
              onChanged: (valor){
              setState(() {
                idMateria = valor!;
              });
              }
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
      ),
    );
  }
}
