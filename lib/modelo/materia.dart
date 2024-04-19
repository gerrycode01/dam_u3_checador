class Materia {
  String nmat; //LLAVE PRIMARIA
  String descripcion;

  Materia({required this.nmat, required this.descripcion});

  Map<String, dynamic> toJSON() {
    return {'nmat': nmat, 'descripcion': descripcion};
  }
}
