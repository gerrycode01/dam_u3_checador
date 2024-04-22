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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Asistencia()));
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
        return const Text('Horarios');
      case 2:
        return const Text('Profesores');
      case 3:
        return const Text('Asistencia');
      default:
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) => Card(

            child: Center(child: Text('Item $index')),
          ),
        );
    }
  }
}
