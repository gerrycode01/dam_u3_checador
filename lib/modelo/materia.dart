class Materia {
  String nmat; //LLAVE PRIMARIA
  String descripcion;

  Materia({required this.nmat, required this.descripcion});

  Map<String, dynamic> toJSON() {
    return {
      'nmat': nmat,
      'descripcion': descripcion};
  }

  Map<String, dynamic> toJSON2() {
    return {
      //'nmat': nmat,
      'descripcion': descripcion};
  }
}
