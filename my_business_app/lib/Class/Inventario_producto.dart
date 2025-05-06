class Inventario_producto {
  int id_inventario_producto;
  int id_inventario;
  int id_producto;
  int cantidad;

  Inventario_producto({
    required this.id_inventario_producto,
    required this.id_inventario,
    required this.id_producto,
    required this.cantidad,
  });

  factory Inventario_producto.fromJson(Map<String, dynamic> json) {
    return Inventario_producto(
      id_inventario_producto: json['id_inventario_producto'] ?? 0,
      id_inventario: json['id_inventario'] ?? 0,
      id_producto: json['id_producto'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
    );
  }
}
