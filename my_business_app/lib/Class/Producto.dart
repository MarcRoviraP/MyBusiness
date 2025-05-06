import 'package:MyBusiness/Class/Inventario_producto.dart';

class Producto {
  int id_producto;
  String nombre;
  String descripcion;
  double precio;
  String url_img;
  int id_empresa;
  int id_categoria;
  Inventario_producto ? inventario_producto;
  Producto({
    required this.id_producto,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.url_img,
    required this.id_empresa,
    required this.id_categoria,
    this.inventario_producto,
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
      inventario_producto: json['inventario_producto'] != null
          ? Inventario_producto.fromJson(json['inventario_producto'][0])
          : null,
    );
  }
}
