class Profesor {
  String nprofesor;
  String nombre;
  String carrera;

  Profesor(
      {required this.nprofesor, required this.nombre, required this.carrera});

  Map<String, dynamic> toJSON() {
    return {
      //'nprofesor': nprofesor,
      'nombre': nombre,
      'carrera': carrera
    };
  }
}
