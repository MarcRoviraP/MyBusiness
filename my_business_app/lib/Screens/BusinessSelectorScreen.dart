import 'package:MyBusiness/Screens/MainScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:MyBusiness/Screens/CreateBusiness.dart';
import 'package:MyBusiness/Screens/JoinBusiness.dart';

class Businessselectorscreen extends StatefulWidget {
  const Businessselectorscreen({super.key});

  @override
  State<Businessselectorscreen> createState() => _BusinessselectorscreenState();
}

class _BusinessselectorscreenState extends State<Businessselectorscreen> {
  List<Widget> screens = <Widget>[
    Joinbusiness(),
    Createbusiness(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'join'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business_outlined),
            label: 'create'.tr(),
          ),
        ],
      ),
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
    );
  }
}
