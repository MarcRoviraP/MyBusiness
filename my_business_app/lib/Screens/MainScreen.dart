import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_business_app/Screens/BusinessSelectorScreen.dart';
import 'package:my_business_app/Screens/VideoWidget.dart';

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
        title: Text(''),
      ),
      body: screens[selectedIndex],
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
