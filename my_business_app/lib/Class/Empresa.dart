class Empresa {
  int id_empresa;
  String nombre;
  String direccion;
  String telefono;

  Empresa({
    required this.id_empresa,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id_empresa: json['id_empresa'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }
}
