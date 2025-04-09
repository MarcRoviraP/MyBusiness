class Usuario {
  int id_usuario;
  String nombre;
  String correo;
  String contrasenya;

  Usuario({
    required this.id_usuario,
    required this.nombre,
    required this.correo,
    required this.contrasenya,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id_usuario: json['id_usuario'] ?? '',
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      contrasenya: json['contraseña'] ?? '',
    );
  }
}
