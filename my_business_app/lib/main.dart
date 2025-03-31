import 'package:flutter/material.dart';
import 'package:my_business_app/Constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://cghpzfumlnoaxhqapbky.supabase.co",
    anonKey: token,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Supabase + Flutter')),
        body: UsuariosList(),
      ),
    );
  }
}

class UsuariosList extends StatefulWidget {
  @override
  _UsuariosListState createState() => _UsuariosListState();
}

class _UsuariosListState extends State<UsuariosList> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    final response = await supabase.from('usuarios').select('*');
    setState(() {
      usuarios = response;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            insertUser();
          },
          child: Text("Insertar usuario"),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(usuarios[index]['nombre']),
                subtitle: Text(usuarios[index]['correo']),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> insertUser() async {
    await supabase.from("usuarios").insert(
        {"nombre": "Marco", "correo": "maraca@gmail.com", "contraseña": "1234"});

      fetchUsuarios();
    
  }
}
