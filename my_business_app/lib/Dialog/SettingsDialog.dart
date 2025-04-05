import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:MyBusiness/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settingsdialog extends StatefulWidget {
  Settingsdialog({super.key});

  List<String> listaColores = [
    "#FFDE3F", // Amarillo
    "#949CAE", // Gris
    "#FF6D66", // Rojo
    "#63A002", // Verde
    "#0063D8", // Azul
    "#B11AC1", // Rosa
  ];

  @override
  State<Settingsdialog> createState() => _SettingsdialogState();
}

class _SettingsdialogState extends State<Settingsdialog> {
  late String eleccionTema = "";
  late String eleccionTemaAux = "";

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    String theme = await Utils().getSharedString(shared_theme);
    setState(() {
      eleccionTema = theme;
      eleccionTemaAux = theme;
    });
  }

  void saveTheme(String listaColor) {
    Utils().setSharedString(shared_theme, listaColor);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.SettingsDialog_settings.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(LocaleKeys.SettingsDialog_notifi.tr()),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text(LocaleKeys.SettingsDialog_theme.tr()),
            onTap: () {},
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.listaColores.length,
              itemBuilder: (context, index) {
                final color = widget.listaColores[index];
                final selected = color == eleccionTema;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      eleccionTema = color;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: selected ? 20 : 15,
                      backgroundColor: Color(
                          int.parse(color.substring(1), radix: 16) +
                              0xFF000000),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(LocaleKeys.SettingsDialog_save.tr()),
          onPressed: () {
            if (eleccionTema == eleccionTemaAux) {
              Navigator.of(context).pop();
              return;
            }

            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(LocaleKeys.SettingsDialog_save.tr()),
                    content: Text(
                        LocaleKeys.SettingsDialog_required_to_see_changes.tr()),
                    actions: [
                      TextButton(
                        child: Text(LocaleKeys.SettingsDialog_reboot.tr()),
                        onPressed: () {
                          saveTheme(eleccionTema);
                          RestartMain.restartApp(context);
                        },
                      ),
                    ],
                  );
                });

            // Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
