import 'package:dam_u3_practica1_checador/vista/VistaAsistencia.dart';
import 'package:dam_u3_practica1_checador/vista/VistaHorario.dart';
import 'package:dam_u3_practica1_checador/vista/VistaMateria.dart';
import 'package:dam_u3_practica1_checador/vista/VistaProfesor.dart';
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
  int _currentIndex = 0; // Corrected variable name for consistency

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
          'CHECADOR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
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
              leading: const Icon(Icons.schedule),
              title: const Text('Horarios'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Horarios()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profesores'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Profesor()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Materias'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Materia()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Asistencias'),
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
        selectedItemColor: Colors.amber[800],
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
