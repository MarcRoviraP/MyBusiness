import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_business_app/Screens/Video.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(('bienvenida').tr() + "\nMy Business",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 50)),
            ),
            Video(),
          ],
        ),
      ),
    );
  }
}
