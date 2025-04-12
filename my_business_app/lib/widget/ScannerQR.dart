import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scannerqr extends StatefulWidget {
  final void Function(String)? onCodeScanned;
  const Scannerqr({super.key, this.onCodeScanned});

  @override
  State<Scannerqr> createState() => _ScannerqrState();
}

class _ScannerqrState extends State<Scannerqr> {
  String code = "";
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final MobileScannerController controller = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              String value = barcode.rawValue ?? "";
              if (code == value) break;
              code = value;
              widget.onCodeScanned?.call(code);
              break;
            }
          },
        ),
      ),
    );
  }
}
