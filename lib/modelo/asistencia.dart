class Asistencia {
  int idasistencia;
  int nhorario;
  String fecha;
  bool asistencia;

  Asistencia({
    required this.idasistencia,
    required this.nhorario,
    required this.fecha,
    required this.asistencia
  });

  Map<String, dynamic> toJSON(){
    return {
      //'idasistencia':idasistencia,
      'nhorario':nhorario,
      'fecha':fecha,
      'asistencia':asistencia
    };
  }
}