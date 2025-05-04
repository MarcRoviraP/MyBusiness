import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Producto.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Theme/ThemeFFDE3F.dart';
import 'package:MyBusiness/main.dart';
import 'package:crypto/crypto.dart';
import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

String password = "1u5vxhBJewQIVPR8";
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnaHB6ZnVtbG5vYXhocWFwYmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0NDQ4NjMsImV4cCI6MjA1OTAyMDg2M30.HZxso5szAGxM4oVOBshU24DHdR0NHUS-P2Ogh8gD9JY";
String shared_mail = "mail";
String shared_userid = "user_id";
String shared_empresa_id = "empresa_id";
String shared_theme = "tema";
String Pendiente = "Pendiente";
String Aceptada = "Aceptada";
String Rechazada = "Rechazada";
String Administrador_empresa = "Administrador";
String Usuario_empresa = "Usuario";
bool currentLocations = false;
String direccion = "";

String rol = "";
Empresa empresa =
    Empresa(id_empresa: 0, nombre: "", direccion: "", telefono: "");
Usuario usuario = Usuario(
  id_usuario: 0,
  nombre: "",
  correo: "",
  contrasenya: "",
);

String bucketProducts = "products";
String bucketChat = "chat";
ColorScheme temaLight = ThemeFFDE3F.lightScheme();
ColorScheme temaDark = ThemeFFDE3F.darkScheme();

String mail = "";
String theme = "";
bool homeScreen = false;
TextTheme? lightTextTheme;
TextTheme? darkTextTheme;

void openNewScreen(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

Future<dynamic> uploadImage(File imageFile, String name, String bucket) async {
  final response =
      await supabaseService.client.storage.from(bucket).upload(name, imageFile);

  return response;
}

Future<void> solicitarPermisoNotificaciones() async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> mostrarNotificacion({
  required String titulo,
  required String cuerpo,
  String payload = "",
  int id = 0,
  String canalId = 'default_channel',
  String canalNombre = 'Notificaciones',
  Importance importancia = Importance.high,
  Priority prioridad = Priority.high,
}) async {
  final androidDetails = AndroidNotificationDetails(
    canalId,
    canalNombre,
    importance: importancia,
    priority: prioridad,
    showWhen: true,
  );

  final notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    id,
    titulo,
    cuerpo,
    notificationDetails,
    payload: payload,
  );
}

void customErrorSnackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: TextStyle(color: const Color.fromARGB(255, 240, 16, 0))),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      duration: const Duration(seconds: 2),
    ),
  );
}

void customSuccessSnackbar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: TextStyle(color: const Color.fromARGB(255, 52, 240, 0))),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      duration: const Duration(seconds: 2),
    ),
  );
}

class Utils {
  Future<void> refreshBusiness() async {
    var usuario_e = await Utils().getUserEmpresa(usuario.id_usuario.toString());
    if (usuario_e.isNotEmpty) {
      var empresaJSON =
          await Utils().getEmpresa(usuario_e[0]['id_empresa'].toString());
      empresa = Empresa.fromJson(empresaJSON[0]);
      rol = usuario_e[0]['rol'];
      // Si existe, redirigir a la pantalla de empresa
    } else {
      empresa = Empresa(
        id_empresa: 0,
        nombre: "",
        direccion: "",
        telefono: "",
      );
      rol = "";
    }
  }
  Future<List<dynamic>> saveProduct(Producto producto) async {
    try {
      final response = await supabaseService.client
          .from('inventario_producto')
          .update({
            "cantidad": producto.cantidad,
          })
          .filter('id_producto', 'eq', producto.id_producto)
          .select('*');
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getList(String buscar) async {
    final response = await supabaseService.client.from(buscar).select('*');
    return response as List<dynamic>;
  }

  Future<List<dynamic>> getChat() async {
    try {
      final response = await supabaseService.client
          .from('chat_empresa')
          .select('*, usuario:usuarios(*)')
          .eq('id_empresa', empresa.id_empresa)
          .order('fecha_envio', ascending: false);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getInventario() async {
    try {
      final response = await supabaseService.client
          .from('inventario')
          .select('*')
          .eq('id_empresa', empresa.id_empresa);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getUserLogin(String mail, String password) async {
    try {
      final response = await supabaseService.client
          .from('usuarios')
          .select('*')
          .eq('correo', mail)
          .eq('contraseña', convertToSha256(password));
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> getCategory(String name) async {
    try {
      final response = await supabaseService.client
          .from('categorias')
          .select('*')
          .eq('nombre', name)
          .eq('id_empresa', empresa.id_empresa);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await supabaseService.client
          .from('categorias')
          .select('*')
          .eq('id_empresa', empresa.id_empresa)
          .order('nombre', ascending: true);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getProductsFromCategory(String category) async {
    try {
      final response = await supabaseService.client
          .from('productos')
          .select('*, inventario_producto(cantidad)')
          .eq('id_empresa', empresa.id_empresa)
          .eq('id_categoria', category)
          .order('nombre', ascending: true);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await supabaseService.client
          .from('productos')
          .select('*, inventario_producto(cantidad)')
          .eq('id_empresa', empresa.id_empresa)
          .order('nombre', ascending: true);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cambiarRol(int user_id, String rol) async {
    try {
      final response = await supabaseService.client
          .from('usuario_empresa')
          .update({
            "rol": rol,
          })
          .filter('id_usuario_emp', 'eq', user_id)
          .select('*');
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> eliminarUsuarioEmpresa(int user_id) async {
    try {
      final response = await supabaseService.client
          .from('usuario_empresa')
          .delete()
          .filter('id_usuario_emp', 'eq', user_id)
          .select('*');
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> updateInvitacionState(
      int user_id, String estado) async {
    try {
      final response = await supabaseService.client
          .from('invitacion_empresa')
          .update({
            "estado": estado,
          })
          .filter('id_empresa', 'eq', empresa.id_empresa)
          .filter('id_usuario', 'eq', user_id)
          .select('*');
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> updateRepeatedInvitacion(Empresa e) async {
    try {
      final response = await supabaseService.client
          .from('invitacion_empresa')
          .update({
            "fecha_solicitud": DateTime.now().toIso8601String(),
            "estado": Pendiente,
          })
          .filter('id_empresa', 'eq', e.id_empresa)
          .filter('id_usuario', 'eq', usuario.id_usuario)
          .select('*');
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getUserMail(String mail) async {
    try {
      final response = await supabaseService.client
          .from('usuarios')
          .select('*')
          .eq('correo', mail);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getEmpresa(String idEmpresa) async {
    try {
      final response = await supabaseService.client
          .from('empresas')
          .select('*')
          .eq('id_empresa', idEmpresa);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getUsersEmpresa() async {
    try {
      final response = await supabaseService.client
          .from('usuario_empresa')
          .select('*,usuario:usuarios(*)')
          .eq('id_empresa', empresa.id_empresa);
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getUserEmpresa(String idUsuario) async {
    try {
      final response = await supabaseService.client
          .from('usuario_empresa')
          .select('*')
          .eq('id_usuario', idUsuario);
      return response;
    } catch (e) {
      return [];
    }
  }

  String convertToSha256(String password) {
    var bytes = utf8.encode(password);
    String hash = sha256.convert(bytes).toString();
    return hash;
  }

  Future<List<dynamic>> insertInTable(
      Map<String, dynamic> params, String tabla) async {
    try {
      var response =
          await supabaseService.client.from(tabla).insert(params).select("*");
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<void> setSharedString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  Future<List<dynamic>> getInvites() async {
    try {
      var response = await supabaseService.client
          .from('invitacion_empresa')
          .select('*, usuario:usuarios(*)')
          .eq('id_empresa', empresa.id_empresa)
          .eq('estado', Pendiente);
      return response;
    } catch (e) {
      return [];
    }
  }
}

// Widget de mapa para seleccionar la ubicación de la empresa
class MapaEmpresaWidget extends StatefulWidget {
  const MapaEmpresaWidget({super.key});

  @override
  _MapaEmpresaWidgetState createState() => _MapaEmpresaWidgetState();
}

class _MapaEmpresaWidgetState extends State<MapaEmpresaWidget> {
  LatLng _selectedLocation = LatLng(39.4625, -0.3739);

  @override
  void dispose() {
    super.dispose();
    currentLocations = false;
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocations) return mapa();
    return FutureBuilder(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          Position position = snapshot.data as Position;
          _selectedLocation = LatLng(position.latitude, position.longitude);
          currentLocations = true;
        }
        return mapa();
      },
    );
  }

  Column mapa() {
    direccion = "${_selectedLocation.latitude},${_selectedLocation.longitude}";

    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                  direccion = "${point.latitude},${point.longitude}";
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _selectedLocation,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    bool permissionEnabled = true;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) permissionEnabled = false;
    }

    if (permission == LocationPermission.deniedForever) {
      permissionEnabled = false;
    }
    if (!permissionEnabled) {
      currentLocations = false;
      return Future.value(
        Position(
          latitude: 39.4625,
          longitude: -0.3739,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 1.0,
          altitudeAccuracy: 1.0,
          headingAccuracy: 1.0,
        ),
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
