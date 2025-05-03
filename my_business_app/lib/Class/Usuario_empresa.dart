import 'package:MyBusiness/Class/Usuario.dart';

class Usuario_emp {
  int id_usuario_emp;
  int id_usuario;
  int id_empresa;
  String rol;
  Usuario? usuario;

  Usuario_emp({
    required this.id_usuario_emp,
    required this.id_usuario,
    required this.id_empresa,
    required this.rol,
    this.usuario,
  });

  factory Usuario_emp.fromJson(Map<String, dynamic> json) {
    return Usuario_emp(
      id_usuario_emp: json['id_usuario_emp'] ?? 0,
      id_usuario: json['id_usuario'] ?? 0,
      id_empresa: json['id_empresa'] ?? 0,
      rol: json['rol'] ?? '',
      usuario:
          json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
    );
  }
}
