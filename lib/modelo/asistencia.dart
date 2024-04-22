class Asistencia {
  int idasistencia; //llave primaria autoincrementable
  int nhorario; //llave foranea
  String fecha;
  bool asistencia;

  Asistencia({
    required this.idasistencia,
    required this.nhorario,
    required this.fecha,
    required this.asistencia
  });

  Map<String, dynamic> toJSON() {
    return {
      //'idasistencia': idasistencia,
      'nhorario': nhorario,
      'fecha': fecha,
      'asistencia': asistencia ? 1 : 0  // Almacena como 1 o 0
    };
  }
}