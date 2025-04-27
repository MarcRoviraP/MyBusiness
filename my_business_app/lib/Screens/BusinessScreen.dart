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
  List<Widget> screens = <Widget>[
    startBusinessScreen(),
    Invitesscreen(),
    Inventoryscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (Route<dynamic> route) => false);
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
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: LocaleKeys.BusinessScreen_start.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline),
            selectedIcon: Icon(Icons.mail),
            label: LocaleKeys.BusinessScreen_invitacions.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            label: LocaleKeys.BusinessScreen_inventory.tr(),
          ),
        ],
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
      ],
    );
  }
}
