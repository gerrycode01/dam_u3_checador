class Todo{
  int nhorario; //llave primaria AUTOINCREMENTABLE
  String nprofesor;
  String nombreProfesor;
  String nmat;
  String descripcionMateria;
  String hora;
  String edificio;
  String salon;
  int idasistencia;
  String fecha;
  bool asistencia;

  Todo(
      {required this.nhorario,
        required this.nprofesor,
        required this.nombreProfesor,
        required this.nmat,
        required this.descripcionMateria,
        required this.hora,
        required this.edificio,
        required this.salon,
        required this.idasistencia,
        required this.fecha,
        required this.asistencia
      });
}