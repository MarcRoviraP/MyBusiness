class Empresa {
  int id_empresa;
  String nombre;
  String direccion;
  String telefono;
  String descripcion;
  String url_img;

  Empresa({
    required this.id_empresa,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.descripcion,
    required this.url_img,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id_empresa: json['id_empresa'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      descripcion: json['descripcion'] ?? '',
      url_img: json['url_img'] ?? '',
    );
  }
}
