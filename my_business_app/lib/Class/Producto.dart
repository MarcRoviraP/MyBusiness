class Producto {
  int id_producto;
  String nombre;
  String descripcion;
  double precio;
  String url_img;
  int id_empresa;
  int id_categoria;

  Producto({
    required this.id_producto,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.url_img,
    required this.id_empresa,
    required this.id_categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id_producto: json['id_producto'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: json['precio'] != null
          ? double.parse(json['precio'].toString())
          : 0.0,
      url_img: json['url_img'] ?? '',
      id_empresa: json['id_empresa'] ?? 0,
      id_categoria: json['id_categoria'] ?? 0,
    );
  }
}
