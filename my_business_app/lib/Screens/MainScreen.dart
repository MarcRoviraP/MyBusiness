import 'dart:math';

import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Dialog/SettingsDialog.dart';
import 'package:MyBusiness/Screens/BusinessScreen.dart';
import 'package:MyBusiness/Screens/Login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:MyBusiness/Screens/BusinessSelectorScreen.dart';
import 'package:MyBusiness/Screens/VideoWidget.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  var em = empresa;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = empresa.id_empresa != 0
        ? <Widget>[
            Inicio(),
            Inicio(),
            Inicio(),
          ]
        : <Widget>[
            Inicio(),
            Inicio(),
          ];

    var destinations = empresa.id_empresa != 0
        ? <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'start'.tr(),
            ),
            NavigationDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business_outlined),
              label: 'business'.tr(),
            ),
            NavigationDestination(
              icon: Icon(Icons.emoji_objects_outlined),
              selectedIcon: Icon(Icons.emoji_objects_rounded),
              label: LocaleKeys.MainScreen_products.tr(),
            ),
          ]
        : <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'start'.tr(),
            ),
            NavigationDestination(
              icon: Icon(Icons.business_outlined),
              selectedIcon: Icon(Icons.business_outlined),
              label: 'business'.tr(),
            ),
          ];
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            if (value == 1) {
              startBusinessScreen(context);
            } else {
              selectedIndex = value;
            }
          });
        },
        selectedIndex: selectedIndex,
        destinations: destinations,
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: cerrarSesion,
          ),
          IconButton(onPressed: openSettings, icon: Icon(Icons.settings)),
        ],
        title: Text(''),
      ),
      body: screens[selectedIndex],
    );
  }

  void startBusinessScreen(BuildContext context) {
    // Busca si existe el id de usuario en la tabla usuario_empresa
    Utils().getUserEmpresa(usuario.id_usuario.toString()).then((value) {
      if (value.isNotEmpty) {
        Utils().getEmpresa(value[0]['id_empresa'].toString()).then((value) {
          empresa = Empresa.fromJson(value[0]);

          // Si existe, redirigir a la pantalla de empresa
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Businessscreen()),
          );
        });
      } else {
        // Si no existe, redirigir a la pantalla de creación de empresa
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Businessselectorscreen()),
        );
      }
    });
  }

  void cerrarSesion() async {
    await Utils().setSharedString(shared_mail, "");
    await Utils().setSharedString(shared_empresa_id, "");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
      (Route<dynamic> route) => false,
    );
    empresa = Empresa(
      id_empresa: 0,
      nombre: "",
      direccion: "",
      telefono: "",
    );
    usuario = Usuario(
      id_usuario: 0,
      nombre: "",
      correo: "",
      contrasenya: "",
    );
  }

  void openSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Settingsdialog();
      },
    );
  }
}

class Inicio extends StatelessWidget {
  const Inicio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Center(
              child: Text("${('bienvenida').tr()}\nMy Business",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 50)),
            ),
            Video(url: 'https://www.youtube.com/watch?v=-pWSQYpkkjk'),
          ],
        ),
      ),
    );
  }
}
