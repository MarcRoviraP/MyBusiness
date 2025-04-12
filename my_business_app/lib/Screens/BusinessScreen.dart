import 'package:MyBusiness/Constants/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
      ),
    );
  }
}
