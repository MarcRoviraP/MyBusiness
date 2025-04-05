import 'package:MyBusiness/Constants/constants.dart';
import 'package:MyBusiness/Dialog/SettingsDialog.dart';
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
  List<Widget> screens = <Widget>[
    Inicio(),
    Inicio(),
    Inicio(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Businessselectorscreen()),
              );
            } else {
              selectedIndex = value;
            }
          });
        },
        selectedIndex: selectedIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'start'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business_outlined),
            label: 'business'.tr(),
          ),
        ],
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

  void cerrarSesion() {
    Utils().setSharedString(shared_mail, "").then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
        (Route<dynamic> route) => false,
      );
    });
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
