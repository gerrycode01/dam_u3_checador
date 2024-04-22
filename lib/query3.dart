import 'package:dam_u3_practica1_checador/controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/materia.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class Query3 extends StatefulWidget {
  const Query3({super.key});

  @override
  State<Query3> createState() => _Query3State();
}

class _Query3State extends State<Query3> {
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;
  List<Profesor> profesores = [];
  List<Materia> materias = [];
  String? idProfesor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarLista();
  }

  void cargarLista() async {
    List<Profesor> l = await DBProfesor.mostrar();
    setState(() {
      profesores = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                // Esto da más espacio al dropdown en proporción al botón
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Profesor",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person, color: azulMarino),
                    filled: true,
                    fillColor: blanco,
                  ),
                  value: idProfesor,
                  onChanged: (String? newValue) {
                    setState(() {
                      idProfesor = newValue;
                    });
                  },
                  items: profesores
                      .map<DropdownMenuItem<String>>((Profesor profesor) {
                    return DropdownMenuItem<String>(
                      value: profesor.nprofesor,
                      child: Text(profesor.nombre),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              // Espacio entre el dropdown y el botón
              ButtonTheme(
                minWidth: 64.0,
                // Ancho mínimo del botón
                height: 60.0,
                // Altura para igualar la del DropdownButtonFormField
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: blanco,
                    backgroundColor: naranja,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    cargarMaterias();
                  },
                  child: const Text('Buscar'),
                ),
              )
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: materias.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(materias[index].descripcion),
                    );
                  }))
        ],
      ),
    );
  }

  void cargarMaterias() async {
    if (idProfesor == null) return;
    List<Materia> materias = await DBMaterias.query3(idProfesor.toString());

    for (var element in materias) {
      print(element.descripcion);
    }

    setState(() {
      this.materias = materias;
    });
  }
}
