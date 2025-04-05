import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
          Container(
            height: 50,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.listaColores.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    saveTheme(widget.listaColores[index]);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(int.parse(
                              widget.listaColores[index].substring(1),
                              radix: 16) +
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
          child: Text(LocaleKeys.SettingsDialog_close.tr()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void saveTheme(String listaColor) {
    Utils().setSharedString(shared_theme, listaColor).then((value) {

        
    });
  }
}
