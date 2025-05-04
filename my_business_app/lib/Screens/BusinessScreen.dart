import 'package:MyBusiness/Class/Empresa.dart';
import 'package:MyBusiness/Screens/BussinesChat.dart';
import 'package:MyBusiness/Screens/EmployeesScreen.dart';
import 'package:MyBusiness/Screens/InventoryScreen.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/InvitesScreen.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Businessscreen extends StatefulWidget {
  const Businessscreen({super.key});

  @override
  State<Businessscreen> createState() => _BusinessscreenState();
}

class _BusinessscreenState extends State<Businessscreen> {
  final MobileScannerController controller = MobileScannerController();
  int selectedIndex = 0;
  List<Widget> screens = rol == "Administrador"
      ? <Widget>[
          startBusinessScreen(),
          Inventoryscreen(),
          Bussineschat(),
          Invitesscreen(),
          Employeesscreen(),
        ]
      : <Widget>[
          startBusinessScreen(),
          Inventoryscreen(),
          Bussineschat(),
        ];

  List<Widget> destinations = rol == "Administrador"
      ? <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: LocaleKeys.BusinessScreen_start.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            label: LocaleKeys.BusinessScreen_inventory.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.mark_unread_chat_alt_outlined),
            selectedIcon: Icon(Icons.mark_unread_chat_alt_sharp),
            label: LocaleKeys.BusinessScreen_chat.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: LocaleKeys.BusinessScreen_invitacions.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            selectedIcon: Icon(Icons.people_alt),
            label: LocaleKeys.BusinessScreen_employee.tr(),
          ),
        ]
      : <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: LocaleKeys.BusinessScreen_start.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            label: LocaleKeys.BusinessScreen_inventory.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.mark_unread_chat_alt_outlined),
            selectedIcon: Icon(Icons.mark_unread_chat_alt_sharp),
            label: LocaleKeys.BusinessScreen_chat.tr(),
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Utils()
                .refreshBusiness()
                .then((value) => openNewScreen(context, MainScreen()));
          },
        ),
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        selectedIndex: selectedIndex,
        destinations: destinations,
      ),
    );
  }
}

class startBusinessScreen extends StatelessWidget {
  const startBusinessScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          empresa.nombre,
          style: TextStyle(fontSize: 30),
        ),
        Center(
          child: QrImageView(
            data: empresa.id_empresa.toString(),
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
        ),
        Text(
          "ID: ${empresa.id_empresa.toString()}",
          style: TextStyle(fontSize: 20),
        ),
        TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(LocaleKeys.BusinessScreen_exit_business.tr()),
                    content:
                        Text(LocaleKeys.BusinessScreen_exit_business_text.tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(LocaleKeys.CreateProducts_cancel.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          salirEmpresa(context);
                        },
                        child: Text(LocaleKeys.BusinessScreen_exit.tr()),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(LocaleKeys.BusinessScreen_exit_business.tr())),
      ],
    );
  }

  Future<void> salirEmpresa(BuildContext context) async {
    if (rol == "Administrador") {
      var usersEmpresa = await Utils().getUsersEmpresa();
      if (usersEmpresa.length > 1) {
        List<dynamic> users = usersEmpresa.map((e) {
          if (e["rol"] == "Administrador" &&
              e["id_usuario"] != usuario.id_usuario) {
            return e["nombre"];
          }
        }).toList();

        if (users.isEmpty) {
          customErrorSnackbar(
              LocaleKeys.BusinessScreen_cannot_exit.tr(), context);
          return;
        }
      }
    }
    Utils().eliminarUsuarioEmpresa(usuario.id_usuario);
    Utils().refreshBusiness();
  }
}
