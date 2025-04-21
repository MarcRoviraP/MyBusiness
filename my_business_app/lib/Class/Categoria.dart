class Categoria {
  int id_categoria;
  String nombre;
  int id_empresa;

  Categoria({
    required this.id_categoria,
    required this.nombre,
    required this.id_empresa,
  });

  

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id_categoria: json['id_categoria'] ?? '',
      nombre: json['nombre'] ?? '',
      id_empresa: json['id_empresa'] ?? '',
    );
  }
}
