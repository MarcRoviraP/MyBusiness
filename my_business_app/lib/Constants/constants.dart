import 'package:my_business_app/API_SUPABASE/supabase_service.dart';


String password = "1u5vxhBJewQIVPR8";
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnaHB6ZnVtbG5vYXhocWFwYmt5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0NDQ4NjMsImV4cCI6MjA1OTAyMDg2M30.HZxso5szAGxM4oVOBshU24DHdR0NHUS-P2Ogh8gD9JY";



class Utils {
  Future<List<dynamic>> getList(String buscar) async {
    final response = await supabaseService.client.from(buscar).select('*');
    return response as List<dynamic>;
  }

  Future<void> insertUser(Map<String, dynamic> params, String tabla) async {
    final response = await supabaseService.client.from(tabla).insert(params);
    print(response);
  }
}
