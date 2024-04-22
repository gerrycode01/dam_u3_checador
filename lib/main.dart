import 'package:dam_u3_practica1_checador/controlador/DB.dart';
import 'package:dam_u3_practica1_checador/modelo/profesor.dart';
import 'package:dam_u3_practica1_checador/vista/asistencias/VistaAsistencia.dart';
import 'package:dam_u3_practica1_checador/vista/horarios/VistaHorario.dart';
import 'package:dam_u3_practica1_checador/vista/materias/VistaMateria.dart';
import 'package:dam_u3_practica1_checador/vista/profesores/VistaProfesor.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;// Corrected variable name for consistency
  final Color azulMarino = Colors.indigo.shade900;
  final Color naranja = Colors.deepOrange;
  final Color blanco = Colors.white;
  final Color negro = Colors.black;
  List<Profesor> profesores = [];
  String? idProfesor;
  String? idMateria;
  String? selectedTime;
  String? selectedEdificio;
  String? selectedSalon;
  final _fechaController = TextEditingController();

  // This function will be used to change the current index
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHECADOR TEC',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade900,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo.jpeg'), // Asegúrate de cambiar esto por el path de tu imagen.
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profesores', style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VistaProfesor()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Materias', style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VistaMateria()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Horarios', style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Horarios()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Asistencias', style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VistaAsistencia()));
              },
            ),

          ],
        ),
      ),
      body: _dynamicContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profesores',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _dynamicContent() {
    switch (_currentIndex) {
      case 1:
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
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
                      items: profesores.map<DropdownMenuItem<String>>((Profesor profesor) {
                        return DropdownMenuItem<String>(
                          value: profesor.nprofesor,
                          child: Text(profesor.nombre),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10),
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
                          _fechaController.text = pickedDate.toString().substring(0, 10); // Formatea la fecha como yyyy-mm-dd
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: blanco, backgroundColor: naranja,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Agregar lógica para la acción de buscar aquí
                },
                child: const Text('Buscar'),
              ),
            ],
          ),
        );
      case 2:
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5, // Esto da más espacio al dropdown en proporción al botón
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
                      items: profesores.map<DropdownMenuItem<String>>((Profesor profesor) {
                        return DropdownMenuItem<String>(
                          value: profesor.nprofesor,
                          child: Text(profesor.nombre),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10), // Espacio entre el dropdown y el botón
                  ButtonTheme(
                    minWidth: 64.0, // Ancho mínimo del botón
                    height: 60.0, // Altura para igualar la del DropdownButtonFormField
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: blanco, backgroundColor: naranja,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Añadir lógica de búsqueda aquí si es necesario
                      },
                      child: const Text('Buscar'),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      default:
        return Padding(
          padding: EdgeInsets.all(10),
           child: (
             Column(
               children: [
                 Row(
                   children: [
                     Expanded(
                       child: DropdownButtonFormField<String>(
                         decoration: InputDecoration(
                           labelText: "Hora",
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                           prefixIcon: Icon(Icons.punch_clock, color: azulMarino),
                           filled: true,
                           fillColor: blanco,
                         ),
                         onChanged: (newValue) {
                           setState(() {
                             selectedTime = newValue;
                           });
                         },
                         items: Conexion.horas.map<DropdownMenuItem<String>>((String value) {
                           return DropdownMenuItem<String>(
                             value: value,
                             child: Text(value),
                           );
                         }).toList(),
                       ),
                     ),
                     SizedBox(width: 10),
                     Expanded(
                       child: DropdownButtonFormField<String>(
                         decoration: InputDecoration(
                           labelText: "Edificio",
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                           prefixIcon: Icon(Icons.apartment, color: azulMarino),
                           filled: true,
                           fillColor: blanco,
                         ),
                         value: selectedEdificio,
                         onChanged: (newValue) {
                           setState(() {
                             selectedEdificio = newValue;
                           });
                         },
                         items: Conexion.edificiosYSalones.keys
                             .map<DropdownMenuItem<String>>((String value) {
                           return DropdownMenuItem<String>(
                             value: value,
                             child: Text(value),
                           );
                         }).toList(),
                       ),
                     ),
                   ],
                 ),
                 SizedBox(height: 20),
                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     foregroundColor: blanco, backgroundColor: naranja,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),
                   onPressed: () {
                     // Añadir lógica de búsqueda aquí si es necesario
                   },
                   child: const Text('Buscar'),
                 ),
               ],
             )
           ),
        );
    }
  }
}
