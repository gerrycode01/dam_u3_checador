import 'package:dam_u3_practica1_checador/controlador/DBProfesor.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:flutter/material.dart';

class Query2 extends StatefulWidget {
  const Query2({super.key});

  @override
  State<Query2> createState() => _Query2State();
}

class _Query2State extends State<Query2> {
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;
  List<Profesor> profesores = [];
  String? idProfesor;
  final _fechaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text("ASISTENCIA DE PROFESORES", style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fechaController,
                  decoration: InputDecoration(
                    hintText: 'Fecha',
                    prefixIcon: Icon(Icons.calendar_today, color: azulMarino),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: blanco,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _fechaController.text = pickedDate.toString().substring(
                          0, 10); // Formatea la fecha como yyyy-mm-dd
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: blanco,
              backgroundColor: naranja,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              cargarProfesores();
            },
            child: const Text('Buscar'),
          ),
          SizedBox(height: 20,),
          Expanded(
              child: ListView.builder(
                  itemCount: profesores.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.person, color: Colors.indigo,),
                            title: Text(profesores[index].nombre,style: TextStyle(color: Colors.deepOrange),),
                          )
                        ],
                      ),
                    );
                  }
                  )
          )

        ],
      ),
    );
  }

  void cargarProfesores() async {
    if (_fechaController.text.isEmpty) return;
    List<Profesor> profesores = await DBProfesor.query2(_fechaController.text);

    for (var element in profesores) {
      print(element.nombre);
    }

    setState(() {
      this.profesores = profesores;
    });
  }
}
