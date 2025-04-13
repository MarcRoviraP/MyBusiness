import 'dart:async';
import 'dart:convert';

import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Class/Usuario.dart';
import 'package:crypto/crypto.dart';
import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:geolocator/geolocator.dart';
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
bool currentLocations = false;
String direccion = "";
Empresa empresa =
    Empresa(id_empresa: 0, nombre: "", direccion: "", telefono: "");
Usuario usuario = Usuario(
  id_usuario: 0,
  nombre: "",
  correo: "",
  contrasenya: "",
);

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
  Future<List<dynamic>> getList(String buscar) async {
    final response = await supabaseService.client.from(buscar).select('*');
    return response as List<dynamic>;
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
  Widget build(BuildContext context) {
    if (currentLocations) return mapa();
    return FutureBuilder(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
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
