import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_business_app/Screens/BusinessSelectorScreen.dart';
import 'package:my_business_app/Screens/CreateBusiness.dart';
import 'package:my_business_app/Screens/JoinBusiness.dart';
import 'package:my_business_app/Screens/VideoWidget.dart';

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
        title: Text(''),
      ),
      body: screens[selectedIndex],
    );
  }
}

