import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Createbusiness extends StatefulWidget {
  const Createbusiness({super.key});

  @override
  State<Createbusiness> createState() => _CreatebusinessState();
}

class _CreatebusinessState extends State<Createbusiness> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("create_business").tr());
  }
}
