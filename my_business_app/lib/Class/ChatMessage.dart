import 'package:MyBusiness/Class/Usuario.dart';

class ChatMessage {
  int id_mensaje;
  int id_empresa;
  int id_usuario;
  String mensaje;
  String imagen_url;
  DateTime fecha_envio;
  Usuario? usuario;

  ChatMessage({
    required this.id_mensaje,
    required this.id_empresa,
    required this.id_usuario,
    required this.mensaje,
    required this.imagen_url,
    required this.fecha_envio,
    this.usuario,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id_mensaje: json['id_mensaje'] ?? 0,
      id_empresa: json['id_empresa'] ?? 0,
      id_usuario: json['id_usuario'] ?? 0,
      mensaje: json['mensaje'] ?? '',
      imagen_url: json['imagen_url'] ?? '',
      fecha_envio:
          DateTime.parse(json['fecha_envio'] ?? DateTime.now().toString()),
      usuario:
          json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
    );
  }
}
