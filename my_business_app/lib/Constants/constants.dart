import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:MyBusiness/API_SUPABASE/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

String password = "1u5vxhBJewQIVPR8";
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnaHB6ZnVtbG5vYXhocWFwYmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0NDQ4NjMsImV4cCI6MjA1OTAyMDg2M30.HZxso5szAGxM4oVOBshU24DHdR0NHUS-P2Ogh8gD9JY";
String shared_mail = "mail";
String shared_theme = "tema";

class Utils {
  Future<List<dynamic>> getList(String buscar) async {
    final response = await supabaseService.client.from(buscar).select('*');
    return response as List<dynamic>;
  }

  Future<bool> getUser(String mail, String password) async {
    final response = await supabaseService.client
        .from('usuarios')
        .select('*')
        .eq('correo', mail)
        .eq('contraseña', convertToSha256(password));
        
      setSharedString(shared_mail, mail);
    return response.isNotEmpty;
  }

  Future<bool> setUser(String name, String mail, String password) async {
    try {
      final response = await supabaseService.client.from('usuarios').insert({
        'nombre': name,
        'correo': mail,
        'contraseña': convertToSha256(password),
      }).select();
      setSharedString(shared_mail, mail);
      return response.isNotEmpty;
    } catch (exception) {
      return false;
    }
  }

  String convertToSha256(String password) {
    var bytes = utf8.encode(password);
    String hash = sha256.convert(bytes).toString();
    return hash;
  }

  Future<void> insertInTable(Map<String, dynamic> params, String tabla) async {
    final response = await supabaseService.client.from(tabla).insert(params);
  }

  Future<void> setSharedString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }
}
