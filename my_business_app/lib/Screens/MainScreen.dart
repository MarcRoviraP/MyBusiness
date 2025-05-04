import 'dart:math';

import 'package:MyBusiness/Class/Usuario.dart';
import 'package:MyBusiness/Screens/ProductsScreen.dart';
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
  const MainScreen({super.key});
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
            Scaffold(),
            ProductsScreen(),
          ]
        : <Widget>[
            Inicio(),
            Scaffold(),
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
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        // Curva de entrada y salida de la animación
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            // Creamos un desplazamiento de -1.0 en el eje x
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          ));

          // Combina la animación de desplazamiento con la animación de opacidad para crear un efecto de deslizamiento y desvanecimiento
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Container(
          // Al cambiar el valor de la key, indicamos a la animación que debe reiniciarse
          key: ValueKey(selectedIndex),
          child: Align(
            alignment: Alignment.topCenter,
            child: screens[selectedIndex],
          ),
        ),
      ),
    );
  }

  Future<void> startBusinessScreen(BuildContext context) async {
    // Busca si existe el id de usuario en la tabla usuario_empresa
    var value = await Utils().getUserEmpresa(usuario.id_usuario.toString());
    if (value.isNotEmpty) {
      var empresaJSON =
          await Utils().getEmpresa(value[0]['id_empresa'].toString());
      empresa = Empresa.fromJson(empresaJSON[0]);
              rol = value[0]['rol'];

      // Si existe, redirigir a la pantalla de empresa
      openNewScreen(context, Businessscreen());
    } else {
      // Si no existe, redirigir a la pantalla de creación de empresa
      openNewScreen(context, Businessselectorscreen());
      empresa = Empresa(
        id_empresa: 0,
        nombre: "",
        direccion: "",
        telefono: "",
      );
    }
  }

  void cerrarSesion() async {
    await Utils().setSharedString(shared_mail, "");
    await Utils().setSharedString(shared_empresa_id, "");
    openNewScreen(context, Login());
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
