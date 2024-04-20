class ProfesorHorario{
  String nprofesor;
  String nombre;
  String carrera;
  int nhorario; //llave primaria AUTOINCREMENTABLE
  String nmat;
  String hora;
  String edificio;
  String salon;

  ProfesorHorario(
      {
        required this.nprofesor,
        required this.nombre,
        required this.carrera,
        required this.nhorario,
        required this.nmat,
        required this.hora,
        required this.edificio,
        required this.salon
      });
}