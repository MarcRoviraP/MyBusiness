import 'package:MyBusiness/Dialog/EditBusinessDialog.dart';
import 'package:MyBusiness/Dialog/ShowImage.dart';
import 'package:MyBusiness/Screens/BussinesChat.dart';
import 'package:MyBusiness/Screens/EmployeesScreen.dart';
import 'package:MyBusiness/Screens/InventoryScreen.dart';
import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Screens/InvitesScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class startBusinessScreen extends StatefulWidget {
  const startBusinessScreen({super.key});

  @override
  State<startBusinessScreen> createState() => _startBusinessScreenState();
}

class _startBusinessScreenState extends State<startBusinessScreen> {
  XFile? picture;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            rol == "Administrador"
                ? TextButton(
                    onPressed: () {
                      Future<bool?> response = showDialog<bool?>(
                        context: context,
                        builder: (context) {
                          return Editbusinessdialog();
                        },
                      );
                      response.then((value) {
                        if (value != null) {
                          if (value) {
                            Utils().refreshBusiness().then((value) {
                              setState(() {});
                            });
                          }
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.edit),
                        Text(LocaleKeys.BusinessScreen_edit_business.tr())
                      ],
                    ))
                : SizedBox(),
            Text(
              empresa.nombre.toUpperCase(),
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            empresa.url_img != ""
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => ShowImage(
                            url:
                                "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/$bucketBusiness//${empresa.url_img}"),
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://cghpzfumlnoaxhqapbky.supabase.co/storage/v1/object/public/$bucketBusiness/${empresa.url_img}",
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ))
                : const SizedBox(),
            SizedBox(
              height: 20,
            ),
            Text(
              empresa.descripcion,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              LocaleKeys.BusinessScreen_join.tr(),
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
                        title:
                            Text(LocaleKeys.BusinessScreen_exit_business.tr()),
                        content: Text(
                            LocaleKeys.BusinessScreen_exit_business_text.tr()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(LocaleKeys.CreateProducts_cancel.tr()),
                          ),
                          TextButton(
                            onPressed: () {
                              salirEmpresa(context).then((value) {
                                Navigator.of(context).pop();
                                if (value) {
                                  openNewScreen(context, MainScreen());
                                } else {
                                  customErrorSnackbar(
                                      LocaleKeys.BusinessScreen_cannot_exit
                                          .tr(),
                                      context);
                                }
                              });
                            },
                            child: Text(
                              LocaleKeys.BusinessScreen_exit.tr(),
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(LocaleKeys.BusinessScreen_exit_business.tr())),
          ],
        ),
      ),
    );
  }

  Future<bool> salirEmpresa(BuildContext context) async {
    bool masAdministradores = false;
    if (rol == "Administrador") {
      var usersEmpresa = await Utils().getUsersEmpresa();
      usersEmpresa.map((e) {
        if (e["rol"] == "Administrador" &&
            e["id_usuario"] != usuario.id_usuario) {
          masAdministradores = true;
        }
      }).toList();

      if (!masAdministradores) {
        bool? response = await showDialog<bool?>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(LocaleKeys.BusinessScreen_delete_business.tr()),
                content:
                    Text(LocaleKeys.BusinessScreen_want_delete_business.tr()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(LocaleKeys.BusinessScreen_cancel.tr()),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(LocaleKeys.BusinessScreen_accept.tr()),
                  ),
                ],
              );
            });
        if (response != null) {
          if (response) {
            await Utils().eliminarTodaEmpresa();
            await Utils().refreshBusiness();
            return true;
          }
        }
        return false;
      }
    }
    await Utils().eliminarUsuarioEmpresaPorUserID(usuario.id_usuario);
    await Utils().refreshBusiness();
    return true;
  }

  Future<XFile?> takePhoto() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.camera);

    return picture;
  }

  Future<XFile?> takePhotoGallery() async {
    XFile? picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picture;
  }
}
